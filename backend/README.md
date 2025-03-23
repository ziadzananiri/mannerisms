# Mannerisms Backend

A FastAPI backend for the Mannerisms app, providing authentication, question management, and user progress tracking.

## Features

- JWT-based authentication
- MongoDB database integration
- Question management (CRUD operations)
- User progress tracking
- RESTful API endpoints

## Prerequisites

- Python 3.8+
- MongoDB Atlas account
- pip (Python package manager)

## Setup

1. Clone the repository
2. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Create a `.env` file in the backend directory with the following variables:
   ```
   MONGO_URI=your_mongodb_atlas_uri
   JWT_SECRET=your_jwt_secret_key
   ```

5. Run the server:
   ```bash
   python run.py
   ```

The server will start at `http://localhost:8000`

## API Documentation

Once the server is running, you can access:
- Interactive API docs (Swagger UI): `http://localhost:8000/docs`
- Alternative API docs (ReDoc): `http://localhost:8000/redoc`

### Authentication Endpoints

#### Login
- **POST** `/token`
- Request body:
  ```json
  {
    "username": "string",
    "password": "string"
  }
  ```
- Returns JWT access token

#### Sign Up
- **POST** `/users/`
- Request body:
  ```json
  {
    "username": "string",
    "password": "string"
  }
  ```
- Returns created user object

### Question Endpoints

#### Get All Questions
- **GET** `/questions/`
- Requires authentication
- Returns list of questions

#### Create Question
- **POST** `/questions/`
- Requires authentication
- Request body:
  ```json
  {
    "question": "string",
    "options": ["string"],
    "correct_answer": "string",
    "explanation": "string",
    "category": "string",
    "difficulty": "string"
  }
  ```
- Returns created question object

#### Submit Answer
- **POST** `/questions/{question_id}/answer`
- Requires authentication
- Request body:
  ```json
  {
    "answer": "string"
  }
  ```
- Returns result with explanation

### Progress Endpoints

#### Get User Progress
- **GET** `/progress/`
- Requires authentication
- Returns user's progress including score and completed questions

## Database Schema

### User Collection
```json
{
  "_id": "ObjectId",
  "username": "string",
  "hashed_password": "string",
  "created_at": "datetime"
}
```

### Question Collection
```json
{
  "_id": "ObjectId",
  "question": "string",
  "options": ["string"],
  "correct_answer": "string",
  "explanation": "string",
  "category": "string",
  "difficulty": "string",
  "created_at": "datetime"
}
```

### UserProgress Collection
```json
{
  "_id": "ObjectId",
  "user": "ObjectId (Reference to User)",
  "score": "integer",
  "completed_questions": ["string"],
  "last_activity": "datetime"
}
```

## Development

### Project Structure
```
backend/
├── app/
│   ├── __init__.py
│   ├── main.py          # FastAPI application and routes
│   ├── models.py        # Database models
│   ├── database.py      # Database connection
│   └── repositories/    # Data access layer
├── requirements.txt     # Python dependencies
├── .env                # Environment variables
└── run.py             # Application entry point
```

### Running Tests
```bash
pytest
```

## Security

- Passwords are hashed using bcrypt
- JWT tokens are used for authentication
- CORS is enabled for frontend access
- Environment variables for sensitive data

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Generating code from OpenAPI specification file

This will output the FastAPI boilerplate to `app_draft`.
```shell
cd backend/
fastapi-codegen --input OpenAPI.yaml --output app_draft
```

After generating the code, copy-paste the necessary snippets from `app_draft/` to `app/` (this includes the models and the endpoint definitions)

## Recipe for OpenAPI specification

### POST Request OpenAPI specification recipe

Sample request body definition
```
/sign-up:
    post:
      summary: Sign up a new user
      description: Registers a new user using an email and password.
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - email
                - password
              properties:
                email:
                  type: string
                  format: email
                  example: "student@utoronto.ca"
                  description: "Must be a valid University of Toronto email (utoronto.ca or mail.utoronto.ca)."
                password:
                  type: string
                  format: password
                  example: "P@ssword123"
                  description: "Must be at least 8 characters, contain 1 uppercase letter, 1 number."
```

Things to notice:
- Always include `summary`, and `requestBody`.
  - `summary` is a one-line summary of the endpoint
  - `description` is a full description of the behaviour of that response (e.g., if the endpoint has pagination and how clients should work with it)
- For `requestBody`
  - make sure it is `required` for POST
  - we always use JSON, specify what schema property are required
  - for each schema property, specify `type`, `format` (if applicable), `example`, and `description`.

