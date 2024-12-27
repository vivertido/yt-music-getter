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
    name TEXT NOT NULL UNIQUE                  -- Artist name
);

CREATE TABLE IF NOT EXISTS albums (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,                        -- Album name
    artist_id INTEGER NOT NULL,                -- Foreign key to the artists table
    FOREIGN KEY (artist_id) REFERENCES artists (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS playlists (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,                 -- Playlist name
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When the playlist was created
    updated_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS playlist_tracks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    playlist_id INTEGER NOT NULL,             -- Foreign key to the playlists table
    track_id INTEGER NOT NULL,                -- Foreign key to the tracks table
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When the track was added to the playlist
    FOREIGN KEY (playlist_id) REFERENCES playlists (id) ON DELETE CASCADE,
    FOREIGN KEY (track_id) REFERENCES tracks (id) ON DELETE CASCADE
);
