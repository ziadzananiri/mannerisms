from mongoengine import connect
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Get MongoDB URI from environment variables
MONGO_URI = os.getenv("MONGO_URI")
if not MONGO_URI:
    raise ValueError("MONGO_URI environment variable is not set")

def connect_db():
    """Connect to MongoDB using the URI from environment variables."""
    try:
        # Add database name to the connection
        connect(host=MONGO_URI, db="mannerisms")
        print("Successfully connected to MongoDB")
    except Exception as e:
        print(f"Error connecting to MongoDB: {e}")
        raise 