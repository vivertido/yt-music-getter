CREATE TABLE IF NOT EXISTS tracks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    artist_id INTEGER NOT NULL,               -- Foreign key to the artists table
    album_id INTEGER NOT NULL,                -- Foreign key to the albums table
    title TEXT NOT NULL,                      -- Track title
    path TEXT NOT NULL UNIQUE,                -- File path on the microSD card
    play_count INTEGER DEFAULT 0,             -- Count of times the track has been played
    last_played TIMESTAMP,                    -- Last time the track was played
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When the track was added to the database
    favorite BOOLEAN DEFAULT 0,               -- Flag to mark the track as a favorite
    FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE,
    FOREIGN KEY (album_id) REFERENCES albums (id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS artists (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,          -- Artist name
    bio TEXT,                           -- Short biography or description
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When the artist was added
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Last time artist details were updated
    image_url TEXT   -- URL to artist image
);

CREATE TABLE IF NOT EXISTS albums (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,                        -- Album name
    artist_id INTEGER NOT NULL,                -- Foreign key to the artists table
    FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,           -- Unique username
    email TEXT,                              -- Email address
    role TEXT NOT NULL DEFAULT 'user',       -- Role (e.g., 'user', 'admin')
    password_hash TEXT,                      -- Hashed password for authentication
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When the user was created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Last updated
);

CREATE TABLE playlists_new (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    is_favorite BOOLEAN DEFAULT 0,
    play_count INTEGER DEFAULT 0,
    last_played TIMESTAMP,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INTEGER NOT NULL, 
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS playlist_tracks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    playlist_id INTEGER NOT NULL,             -- Foreign key to the playlists table
    track_id INTEGER NOT NULL,                -- Foreign key to the tracks table
    position INTEGER NOT NULL DEFAULT 1,      -- Position of the track in the playlist
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When the track was added to the playlist
    updated_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Last updated
    FOREIGN KEY (playlist_id) REFERENCES playlists (id) ON DELETE CASCADE,
    FOREIGN KEY (track_id) REFERENCES tracks (id) ON DELETE CASCADE,
    UNIQUE (playlist_id, track_id)            -- Ensure unique track-playlist pairs
);
