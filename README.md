# You Tube Music Getter
A Flask App that works with [yt_dlp](https://github.com/yt-dlp/yt-dlp) to download playlist MP3 files and stores them on a MicroSD card on a Raspberry Pi. It is also a music player that allows you to stream the collected music to any browser on a local network via a browser client. It is currently a WIP.

This app will:
 - Download full Video playlists from YouTube when given an artist name and a valid YouTube playlist URL. (individual videos also work)
 - Extract the audio file in MP3 format for each track.
 - Store the files in a removable storage drive or SD card - by artist, then by album (The playlist title is the album)
 - Display all downloaded music in the /Music page of the app.
 - Play tracks randomly, or by artist/album using the default browser media player.
 - Displays artist image using Deezer's free API if one is available (no key required).

## Setup
Note: This app has only been tested on a Raspberry Pi 4. 

- Update your Pi `$ sudo apt-get update`
- Install `yt-dlp` by following the instructions on their repo [here](https://github.com/yt-dlp/yt-dlp)
- Clone this repo to a Raspberry Pi: ` $ git clone https://github.com/vivertido/yt-music-getter.git`
- Connect a microSD card or USB storage device of your choice to your Raspberry Pi. Media storage devices should appear in the `/media/pi/<your_device_id>` folder.
- Create a dedicated directory on that device to store all of the music files, for example `/media/pi/9C33-6BBD/Music-Library`
- Update the `app.py` Flask file with your Music Library Path:
  
   ```python

   albums_path = '/media/pi/<SOME-DRIVE>/Music-Library'

   ```

 - Update the `song_getter4.sh` Shell file with this path as well.

```bash

# Music base directory
music_base="/media/pi/<SOME-DRIVE>/Music-Library"

```

## Usage
- Run the app on the Raspberry Pi (connected to a local wifi network) by navigating to the project directory (`/path_to_your_project/song_extractions`) and running

  ```python
   $ python app.py
  
  ```
- Go to a browser on the pi and verify that it works using `localhost:5000`
- Find your Raspberry Pi IP address by running `$ hostname -I` . It should return something like `10.2.34.143` You can use this to connect from other devices on the same local network bu adding typing this IP address into a browser search bar along with the port, as in `10.2.34.143:5000`.  
- Find a playlist on YouTube that you have permission to download. Copy the URL and paste in in the home page of the Flask app. Paste or type the artist name and click Get Music.
- Wait for dowload to conclude. You can go to the /explore page to see if songs are present.
- Go to /player to stream and play music from any connected device!

## Next Steps
This app still needs the following feature upgrades:
- Use SQLite to store the songs in an local database for better UX.
- Allow for remote streaming via a Cloudlfare tunnel.
- Allow for the creation of playlists and saving favorite tracks.
- Authentication.



