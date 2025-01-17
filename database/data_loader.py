import sqlite3
import os
from mutagen.mp3 import MP3
from config import MUSIC_LIBRARY_PATH
import os
from mutagen.mp3 import MP3
 
DB_PATH = "database/music.db"
SCHEMA_PATH = "database/schema.sql"
MUSIC_DIR = MUSIC_LIBRARY_PATH

def initialize_database():
    """Initialize the database using the schema.sql file.
    This function is called when the app is started for the first time. 
    Comment out the call to  this function after the first run to avoid 
    reinitializing the database.
    """
    conn = sqlite3.connect(DB_PATH)
    with open(SCHEMA_PATH, "r") as schema_file:
        conn.executescript(schema_file.read())
    conn.commit()
    conn.close()
    print("Database initialized using schema.sql.")


def sync_tracks():
    """
    Sync tracks from the filesystem with the database.
    Ensures foreign key constraints are satisfied.
    """
    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON;")  # Ensure foreign key constraints are enforced
    cursor = conn.cursor()

    for root, _, files in os.walk(MUSIC_DIR):
        for file in files:
            if file.endswith(".mp3"):
                # Build full file path
                path = os.path.join(root, file)

                # Extract metadata dynamically
                # Assuming structure: Artist/Album/Title.mp3 or Artist/Title.mp3
                relative_path = os.path.relpath(path, MUSIC_DIR)
                parts = relative_path.split(os.sep)
                if len(parts) == 2:  # Artist/Title.mp3
                    artist_name = parts[0]
                    album_name = "Singles"
                    title = parts[1].replace(".mp3", "")
                elif len(parts) >= 3:  # Artist/Album/Title.mp3
                    artist_name = parts[0]
                    album_name = parts[1]
                    title = parts[2].replace(".mp3", "")
                else:
                    print(f"Skipping unsupported file structure: {path}")
                    continue

                # Ensure artist exists
                cursor.execute("INSERT OR IGNORE INTO artists (name) VALUES (?)", (artist_name,))
                artist_id = cursor.execute("SELECT id FROM artists WHERE name = ?", (artist_name,)).fetchone()[0]

                # Ensure album exists
                cursor.execute("INSERT OR IGNORE INTO albums (name, artist_id) VALUES (?, ?)", (album_name, artist_id))
                album_id = cursor.execute("SELECT id FROM albums WHERE name = ? AND artist_id = ?", (album_name, artist_id)).fetchone()[0]

                # Insert track if it doesn't exist
                cursor.execute("""
                    INSERT OR IGNORE INTO tracks (title, artist_id, album_id, path, play_count, last_played, added_date, favorite)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """, (title, artist_id, album_id, path, 0, None, None, 0))  # Default values for new tracks

                print(f"Synced track: {title} (Artist: {artist_name}, Album: {album_name})")

    conn.commit()
    conn.close()
    print("Tracks synced with the database.")



def create_users_table():
    print("Creating users table...")
    create_users_table_sql = """
        CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,           -- Unique username
        email TEXT,                              -- Email address
        role TEXT NOT NULL DEFAULT 'user',       -- Role (e.g., 'user', 'admin')
        password_hash TEXT,                      -- Hashed password for authentication
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When the user was created
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Last updated
        );
        """

    # Connect to the SQLite database
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # Execute the SQL command to create the users table
    cursor.execute(create_users_table_sql)

    # Commit the transaction
    conn.commit()

    # Close the connection
    conn.close()

def sync_artists():
    """
    Scan the music library and add folders as artists to the database.
    """
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # Scan top-level folders in the music directory
    for root, dirs, _ in os.walk(MUSIC_DIR):
        for folder in dirs:
            artist_name = folder.strip()

            # Insert artist with placeholder values for genre, country, bio, and image_url
            cursor.execute("""
                INSERT OR IGNORE INTO artists (name, bio, image_url)
                VALUES (?, ?, ?)
            """, (artist_name, None, None))

            print(f"Synced artist: {artist_name}")
        break  # Process only top-level folders

    conn.commit()
    conn.close()
    print("Artists synced with the music library.")


def extract_added_date(path):
    """Extract the added date from metadata or file properties."""
    try:
        # Try to extract added date from metadata
        audio = MP3(path)
        if "TXXX:Added Date" in audio:
            return audio["TXXX:Added Date"].text[0]
    except Exception as e:
        print(f"Metadata extraction failed for {path}: {e}")

    # Fallback: Use file's last modified time
    file_stats = os.stat(path)
    return file_stats.st_mtime  # Last modified timestamp as a fallback


if __name__ == "__main__":
    #initialize_database()
    #create_users_table() 
    #sync_filesystem()
    #sync_artists()
    sync_tracks()

 