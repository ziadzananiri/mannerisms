from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime, timedelta
from typing import Optional, List
from jose import JWTError, jwt
from passlib.context import CryptContext
from pydantic import BaseModel, Field, ConfigDict
from bson import ObjectId
from .models import User, Question, UserProgress
from .database import connect_db
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Initialize database connection
connect_db()

# Security configuration
SECRET_KEY = os.getenv("JWT_SECRET")
if not SECRET_KEY:
    raise ValueError("JWT_SECRET environment variable is not set")

REFRESH_SECRET_KEY = os.getenv("JWT_SECRET")

ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 120
REFRESH_TOKEN_EXPIRE_DAYS = 7

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

app = FastAPI(title="Mannerisms API")

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Pydantic models
class PyObjectId(str):
    @classmethod
    def __get_validators__(cls):
        yield cls.validate

    @classmethod
    def validate(cls, v, handler):
        if not ObjectId.is_valid(v):
            raise ValueError("Invalid objectid")
        return str(v)

    @classmethod
    def __get_pydantic_json_schema__(cls, field_schema):
        field_schema.update(type="string")
        return field_schema

class Token(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str

class TokenData(BaseModel):
    username: Optional[str] = None

class RefreshToken(BaseModel):
    refresh_token: str

class UserCreate(BaseModel):
    username: str
    password: str

class UserResponse(BaseModel):
    id: PyObjectId = Field(default_factory=PyObjectId, alias="_id")
    username: str
    created_at: datetime

    model_config = ConfigDict(populate_by_name=True)

class QuestionCreate(BaseModel):
    question: str
    options: List[str]
    correct_answer: str
    explanation: str
    category: str
    difficulty: str

class QuestionResponse(BaseModel):
    id: PyObjectId = Field(default_factory=PyObjectId, alias="_id")
    question: str
    options: List[str]
    correct_answer: str
    explanation: str
    category: str
    difficulty: str
    tag: str
    culture: str
    created_at: datetime

    model_config = ConfigDict(populate_by_name=True)

class UserProgressResponse(BaseModel):
    id: PyObjectId = Field(default_factory=PyObjectId, alias="_id")
    user: UserResponse
    score: int
    completed_questions: List[str]
    last_activity: datetime

    model_config = ConfigDict(populate_by_name=True)

class AnswerSubmission(BaseModel):
    user_answer: str

# Security functions
def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def create_refresh_token(data: dict):
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(days=REFRESH_TOKEN_EXPIRE_DAYS)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, REFRESH_SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

async def get_current_user(token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        token_data = TokenData(username=username)
    except JWTError:
        raise credentials_exception
    user = User.objects(username=token_data.username).first()
    if user is None:
        raise credentials_exception
    return user

# Authentication endpoints
@app.post("/token", response_model=Token)
async def login_for_access_token(form_data: OAuth2PasswordRequestForm = Depends()):
    user = User.objects(username=form_data.username).first()
    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    refresh_token = create_refresh_token(data={"sub": user.username})
    return {"access_token": access_token, "refresh_token": refresh_token, "token_type": "bearer"}

@app.post("/refresh", response_model=Token)
async def refresh_token(refresh_token: RefreshToken):
    try:
        payload = jwt.decode(refresh_token.refresh_token, REFRESH_SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        
        user = User.objects(username=username).first()
        if user is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="User not found"
            )

        access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
        new_access_token = create_access_token(
            data={"sub": user.username}, expires_delta=access_token_expires
        )
        new_refresh_token = create_refresh_token(data={"sub": user.username})
        
        return {
            "access_token": new_access_token,
            "refresh_token": new_refresh_token,
            "token_type": "bearer"
        }
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid refresh token"
        )

@app.post("/users/", response_model=UserResponse)
def create_user(user: UserCreate):
    db_user = User.objects(username=user.username).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Username already registered")
    hashed_password = get_password_hash(user.password)
    db_user = User(
        username=user.username,
        hashed_password=hashed_password
    )
    db_user.save()
    return db_user

# Question endpoints
@app.get("/questions/", response_model=List[QuestionResponse])
def get_questions(culture: Optional[str] = None):
    if culture:
        return list(Question.objects(culture=culture))
    return list(Question.objects.all())

@app.post("/questions/", response_model=QuestionResponse)
def create_question(
    question: QuestionCreate,
    current_user: User = Depends(get_current_user)
):
    db_question = Question(**question.dict())
    db_question.save()
    return db_question

@app.post("/questions/{question_id}/answer")
async def submit_answer(
    question_id: str,
    answer: AnswerSubmission,
    current_user: User = Depends(get_current_user)
):
    question = Question.objects(id=question_id).first()
    if not question:
        raise HTTPException(status_code=404, detail="Question not found")
    
    is_correct = answer.user_answer == question.correct_answer
    
    progress = UserProgress.objects(user=current_user).first()
    
    if not progress:
        progress = UserProgress(user=current_user)
    
    if is_correct:
        if question.tag not in progress.completed_questions:
            progress.score += 1
            progress.completed_questions.append(question.tag)
    
    progress.last_activity = datetime.utcnow()
    progress.save()
    
    return {
        "correct": is_correct,
        "explanation": question.explanation
    }

# Progress endpoints
@app.get("/progress/", response_model=UserProgressResponse)
def get_user_progress(current_user: User = Depends(get_current_user)):
    progress = UserProgress.objects(user=current_user).first()
    
    if not progress:
        progress = UserProgress(user=current_user)
        progress.save()
    
    return progress 