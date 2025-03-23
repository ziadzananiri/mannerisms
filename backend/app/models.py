from mongoengine import Document, StringField, IntField, ListField, DateTimeField, ReferenceField
from datetime import datetime

class User(Document):
    username = StringField(required=True, unique=True)
    hashed_password = StringField(required=True)
    created_at = DateTimeField(default=datetime.utcnow)

    meta = {
        'collection': 'users',
        'indexes': ['username']
    }

class Question(Document):
    question = StringField(required=True)
    options = ListField(StringField(), required=True)
    correct_answer = StringField(required=True)
    explanation = StringField(required=True)
    category = StringField(required=True)
    difficulty = StringField(required=True)
    tag = StringField(required=True)
    culture = StringField(required=True)
    created_at = DateTimeField(default=datetime.utcnow)

    meta = {
        'collection': 'questions',
        'indexes': ['category', 'difficulty', 'tag']
    }

class UserProgress(Document):
    user = ReferenceField(User, required=True)
    score = IntField(default=0, required=True)
    completed_questions = ListField(StringField(), default=list)
    last_activity = DateTimeField(default=datetime.utcnow)

    meta = {
        'collection': 'user_progress',
        'indexes': ['user']
    } 