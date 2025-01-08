# YouTube Music Getter

A Flask App that works with [yt_dlp](https://github.com/yt-dlp/yt-dlp) to download playlist MP3 files and store them on a MicroSD card or USB storage on a Raspberry Pi. It also functions as a music player that allows you to stream and play the downloaded music.

## Features

- Download full video playlists from YouTube or individual videos by providing an artist name and a valid YouTube playlist URL.
- Extract audio files in MP3 format for each track.
- Store the files in a removable storage drive or SD card, organized by artist and album.
- Display all downloaded music on the /Music page of the app.
- Play tracks randomly or by artist/album using the default browser media player.
- Display artist images using Deezer's free API if available (no key required).

## Setup

Note: This app has only been tested on a Raspberry Pi 4.

1. Update your Pi:
   ```bash
   sudo apt-get update
   ```
Install yt-dlp by following the instructions on their repo [here](https://github.com/yt-dlp/yt-dlp).

2. Clone this repo to your Raspberry Pi:

`$ git clone https://github.com/vivertido/yt-music-getter.git`

3. Connect a microSD card or USB storage device to your Raspberry Pi. Media storage devices should appear in the /media/pi/<your_device_id> folder.

4. Create a dedicated directory on the device to store all music files, e.g., /media/pi/9C33-6BBD/Music-Library.

5. Update the app.py Flask file with your Music Library Path:

`albums_path = '/media/pi/<SOME-DRIVE>/Music-Library'`

6. Update the song_getter4.sh Shell file with this path:

```bash
# Music base directory
music_base="/media/pi/<SOME-DRIVE>/Music-Library"
```
## Usage
1. Run the app on the Raspberry Pi (connected to a local WiFi network) by navigating to the project directory (/path_to_your_project/song_extractions) and running:
```python
python app.py
```
2. Open a browser on the Pi and verify that it works using localhost:5000.

3. Find your Raspberry Pi IP address by running:

`$ hostname -I`

It should return something like 10.2.34.143. Use this to connect from other devices on the same local network by adding the IP address to your browser.

4. Find a playlist on YouTube that you have permission to download. Copy the URL and paste it on the home page of the Flask app. Enter the artist name and click "Get Music".

5. Wait for the download to complete. You can go to the /explore page to check if the songs are present.

6. Go to /player to stream and play music from any connected device!

## Next Steps
This app still needs the following feature upgrades:

- Use SQLite to store the songs in a local database for better UX.
- Allow for remote streaming via a Cloudflare tunnel.
- Enable creation of playlists and saving favorite tracks.
- Implement authentication.
