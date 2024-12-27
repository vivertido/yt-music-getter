# You Tube Music Getter
A Flask App that works with [yt_dlp](https://github.com/yt-dlp/yt-dlp) to download playlist MP3 files and stores them on a MicroSD card on a Raspberry Pi. It is also a music player that allows you to stream the collected music to any browser on a local network via a browser client. It is currently a WIP.

### Setup
Note: This app has only been tested on a Raspberry Pi 4. 

- Update your Pi `$ sudo apt-get update`
- Install `yt-dlp` by following the instructions on their repo [here](https://github.com/yt-dlp/yt-dlp)
- Clone this repo to a Raspberry Pi: 
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





