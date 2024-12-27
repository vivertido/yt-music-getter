#!/bin/bash

# Input variables
link=$1
artist=$2

# Music base directory
music_base="/media/pi/9C33-6BBD/Music-Library"

# Create artist directory if it doesn't exist
artist_dir="${music_base}/${artist}"
mkdir -p "$artist_dir"

# Function to clean up the title
cleanup_title() {
    echo "$1" | sed -E 's/[^a-zA-Z0-9 _-]+//g' | tr -s ' ' | tr ' ' '_'
}

# Download songs and thumbnails
yt-dlp -x -i --yes-playlist --verbose --audio-format mp3 \
       --output "${artist_dir}/%(playlist_title)s/%(title)s.%(ext)s" \
       "$link"

# Explicitly clean up temp .m4a files
find "${artist_dir}" -type f -name '*.m4a' | while read -r temp_file; do
    echo "Removing leftover temp file: $temp_file"
    rm "$temp_file"
done

# Rename files to clean up titles
find "${artist_dir}" -type f -name '*.mp3' -o -name '*.jpg' | while read -r file; do
    # Extract directory, base name, and extension
    dir=$(dirname "$file")
    base=$(basename "$file")
    ext="${base##*.}"
    base="${base%.*}"
    
    # Clean up the base filename
    clean_base=$(cleanup_title "$base")
    mv "$file" "$dir/$clean_base.$ext"
done
# Add metadata (Artist and Album Name)
find "${artist_dir}" -type f -name '*.mp3' | while read -r mp3; do
    # Extract playlist name from the directory structure
    album_name=$(basename "$(dirname "$mp3")")

    echo "Adding metadata to $mp3"
    
    # Use eyeD3 to set artist and album metadata
    eyeD3 --artist="$artist" --album="$album_name" "$mp3"
    
    if [ $? -ne 0 ]; then
        echo "Failed to add metadata to $mp3"
    fi
done


