# Mannerisms

A mobile application designed to help users improve their social skills and mannerisms through interactive learning and practice.

## Features

- User Authentication (Login/Signup)
- Interactive Learning Modules
- Profile Management (Future)
- Settings Management (Future)
- Modern Black and Purple Theme

## Tech Stack

- Backend: FastAPI (Python)
- Frontend: Flutter with MVVM Architecture
- Database: MongoDB
- Authentication: JWT Tokens

## Project Structure

```
├── backend/           # FastAPI backend
├── frontend/         # Flutter frontend
└── README.md         # Project documentation
```

## Getting Started

### Backend Setup
1. Navigate to the backend directory
2. Create a virtual environment
3. Install dependencies: `pip install -r requirements.txt`
4. Run the server: `uvicorn app.main:app --reload`

Note: You will need a .env file containing a MONGO_URI and JWT_SECRET string.

### Frontend Setup
1. Navigate to the frontend directory
2. Install dependencies: `flutter pub get`
3. Run the app: `flutter run`
