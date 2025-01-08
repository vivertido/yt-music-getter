from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

MUSIC_LIBRARY_PATH = os.getenv("MUSIC_LIBRARY_PATH", None)

if not MUSIC_LIBRARY_PATH or not os.path.exists(MUSIC_LIBRARY_PATH):
    raise ValueError("Music library path is not set or does not exist. Please set MUSIC_LIBRARY_PATH.")

 
