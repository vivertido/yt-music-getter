#!/bin/bash

# Set the directory to start the search
SEARCH_DIR="/media/pi/9C33-6BBD1/Music-Library/Lucid Vox"
LOG_FILE="invalid_mp3_files.log"

# Clear or create the log file
> "$LOG_FILE"

# Initialize counters
file_count=0
invalid_count=0

# Function to recursively check MP3 files
check_mp3_files() {
    echo "Starting scan..."
    find "$1" -type f -name "*.mp3" | while read -r file; do
        file_count=$((file_count + 1))
        echo "Processing file #$file_count: $file"
        
        # Run mp3val and capture output
        output=$(mp3val "$file" 2>&1)
        
        # Check specifically for "Unknown file format"
        if echo "$output" | grep -q "Unknown file format"; then
            echo "Invalid MP3: $file" | tee -a "$LOG_FILE"
            invalid_count=$((invalid_count + 1))
        fi
    done
}

# Run the function on the specified directory
echo "Scanning directory: $SEARCH_DIR"
check_mp3_files "$SEARCH_DIR"

echo "Scan completed!"
echo "Total files scanned: $file_count"
echo "Invalid MP3 files found: $invalid_count"
echo "Invalid files logged in: $LOG_FILE"
