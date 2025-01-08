import sqlite3
import os
from mutagen.mp3 import MP3
from config import MUSIC_LIBRARY_PATH

DB_PATH = "database/music.db"
SCHEMA_PATH = "database/schema.sql"
MUSIC_DIR = MUSIC_LIBRARY_PATH

def initialize_database():
    """Run the schema.sql file to initialize the database."""
    conn = sqlite3.connect(DB_PATH)
    with open(SCHEMA_PATH, "r") as schema_file:
        conn.executescript(schema_file.read())
    conn.close()
    print("Database initialized.")

def populate_initial_data():
    """Populate the database with initial data."""
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # Insert sample artists
    artists = [
        ("Artist 1",),
        ("Artist 2",),
        ("Artist 3",)
    ]
    cursor.executemany("INSERT OR IGNORE INTO artists (name) VALUES (?)", artists)

    # Insert sample albums
    albums = [
        ("Album 1", 1),  # Album name, artist_id
        ("Album 2", 2),
        ("Album 3", 3)
    ]
    cursor.executemany("INSERT OR IGNORE INTO albums (name, artist_id) VALUES (?, ?)", albums)

    # Insert sample tracks
    tracks = [
        ("Track 1", 1, 1, "/path/to/track1.mp3"),
        ("Track 2", 2, 2, "/path/to/track2.mp3"),
        ("Track 3", 3, 3, "/path/to/track3.mp3")
    ]
    cursor.executemany(
        "INSERT OR IGNORE INTO tracks (title, artist_id, album_id, path) VALUES (?, ?, ?, ?)",
        tracks
    )

    # Insert sample playlists
    playlists = [
        ("My Favorites",),
        ("Workout Mix",)
    ]
    cursor.executemany("INSERT OR IGNORE INTO playlists (name) VALUES (?)", playlists)

    # Insert sample playlist tracks
    playlist_tracks = [
        (1, 1),  # Playlist ID, Track ID
        (1, 2),
        (2, 3)
    ]
    cursor.executemany(
        "INSERT OR IGNORE INTO playlist_tracks (playlist_id, track_id) VALUES (?, ?)",
        playlist_tracks
    )

    conn.commit()
    conn.close()
    print("Initial data populated.")

def sync_filesystem():
    """Sync tracks from the filesystem with the database."""
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    for root, _, files in os.walk(MUSIC_DIR):
        for file in files:
            if file.endswith(".mp3"):
                # Build full file path
                path = os.path.join(root, file)

                # Extract metadata dynamically
                # Assuming structures: Artist/Album/Title.mp3 or Artist/Title.mp3
                parts = path.split(os.sep)[-3:]
                if len(parts) == 3:  # Artist/Album/Title.mp3
                    artist_name, album_name, title = parts[0], parts[1], parts[2].replace(".mp3", "")
                elif len(parts) == 2:  # Artist/Title.mp3
                    artist_name, album_name, title = parts[0], "Single Tracks", parts[1].replace(".mp3", "")
                else:
                    print(f"Skipping unsupported file structure: {path}")
                    continue

                # Extract added date (try metadata first, then fallback to file properties)
                added_date = extract_added_date(path)

                # Insert or get artist ID
                cursor.execute("INSERT OR IGNORE INTO artists (name) VALUES (?)", (artist_name,))
                artist_id = cursor.execute("SELECT id FROM artists WHERE name = ?", (artist_name,)).fetchone()[0]

                # Insert or get album ID
                cursor.execute("INSERT OR IGNORE INTO albums (name, artist_id) VALUES (?, ?)", (album_name, artist_id))
                album_id = cursor.execute("SELECT id FROM albums WHERE name = ?", (album_name,)).fetchone()[0]

                # Insert track if it doesn't exist
                cursor.execute("""
                    INSERT OR IGNORE INTO tracks (title, artist_id, album_id, path, play_count, last_played, added_date, favorite)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """, (title, artist_id, album_id, path, 0, None, added_date, 0))  # Default values for new tracks

    conn.commit()
    conn.close()
    print("Filesystem synced with the database.")

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
    initialize_database()
     
    sync_filesystem()