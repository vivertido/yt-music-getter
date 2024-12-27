from flask import Flask, jsonify,render_template, request, session, url_for, redirect,send_from_directory 
import sqlite3
import subprocess
from datetime import datetime
import os
import random
import requests


app = Flask(__name__)

albums_path = '/media/pi/9C33-6BBD/Music-Library'

def fetch_artist_image(artist_name):
    """Fetch artist image from Deezer API."""
    url = f"https://api.deezer.com/search/artist?q={artist_name}"
    response = requests.get(url)
    
    if response.status_code == 200:
        data = response.json()
        # Return the first artist's image if available
        if "data" in data and data["data"]:
            return data["data"][0].get("picture_medium", "https://via.placeholder.com/100")
    return "https://via.placeholder.com/100"


@app.route("/artist_image/<artist_name>")
def artist_image(artist_name):
    image_url = fetch_artist_image(artist_name)
    return jsonify({"image_url": image_url})


def get_all_albums():

    directory_contents = sorted(os.listdir(albums_path))

    #print("Contents of sorted media folder: ")
    #print(directory_contents)

    data = []

    for artist in directory_contents:

        #prevent hidden files...
        if not artist.startswith("."):
            artist_tracks = []
            artist_data ={"artist": artist, "artist_tracks": artist_tracks}
            
            for track in os.scandir(albums_path+'/'+artist):
                
                #store the artist, track_name and path to track
                #track_path = albums_path + "/" + artist + "/" + track.name
                
                track_data = {"track_name" : track.name, 
                            "track_path": track.path
                            }
                
                artist_tracks.append(track_data)
            
            ## NOw add the track data to artist dict
            artist_data.update(artist_tracks)

            #print(artist_data)

            data.append(artist_data)
                
    #print(data)

    return data

@app.route("/get_music" , methods=['POST'])
def get_music():

    print("getting music...")

    artist = request.form["artist"]
    link = request.form["yt-link"]

    subprocess.run(['./song_getter4.sh' , link, artist])

    return redirect(url_for("home"))

@app.route("/artist/<artist_name>/<path:subfolder>")
@app.route("/artist/<artist_name>", defaults={'subfolder': None})
def artist(artist_name, subfolder):
    # Determine the base path for the artist
    base_path = os.path.join(albums_path, artist_name)
    
    # If a subfolder is specified, navigate into it
    if subfolder:
        artist_path = os.path.join(base_path, subfolder)
    else:
        artist_path = base_path

    # Check if the artist path exists
    if not os.path.exists(artist_path):
        return f"Folder '{artist_path}' not found.", 404

    # Get subfolders and songs in the current directory
    subfolders = []
    songs = []
    for item in os.scandir(artist_path):
        if item.is_dir():
            subfolders.append(item.name)
        elif item.is_file() and item.name.endswith(".mp3"):
            songs.append(item.name)

    # Pass data to the template
    return render_template(
        "artist.html",
        artist_name=artist_name,
        subfolders=subfolders,
        songs=songs,
        subfolder=subfolder,
        base_path=artist_path.replace(albums_path, "")
    )



@app.route("/")
def home():
    

    return render_template("index.html")

@app.route("/stream/<artist_name>/<path:song_path>")
def stream(artist_name, song_path):
    # Construct the full path to the file
    artist_path = os.path.join(albums_path, artist_name)
    full_path = os.path.join(artist_path, song_path)
    
    # Check if the file exists
    if not os.path.exists(full_path):
        return f"File '{song_path}' not found in artist '{artist_name}'.", 404
    
    # Serve the file
    return send_from_directory(artist_path, song_path)


@app.route("/music")
def music():
    # Get artist directories
    directory_contents = sorted(os.listdir(albums_path))
    artists = [artist for artist in directory_contents if not artist.startswith(".")]

    # Group artists by their starting letter
    grouped_artists = {}
    for artist in artists:
        first_letter = artist[0].upper()
        grouped_artists.setdefault(first_letter, []).append(artist)

    return render_template("music.html", artists=grouped_artists)

@app.route("/get_tracks", methods=["GET"])
def get_tracks():
    mode = request.args.get("mode", "all")
    artist = request.args.get("artist", "")
    album = request.args.get("album", "")
    offset = int(request.args.get("offset", 0))

    all_tracks = []
    selected_tracks = []

    if mode == "all":
        # Get all tracks in the Music folder
        for root, dirs, files in os.walk(albums_path):
            for file in files:
                if file.endswith(".mp3"):
                    all_tracks.append(os.path.join(root, file).replace(albums_path, "/stream"))

        # Select 20 random tracks starting from the offset
        random.shuffle(all_tracks)
        selected_tracks = all_tracks[offset:offset + 50]

    elif mode == "artist":
        # Get all tracks for the selected artist
        artist_path = os.path.join(albums_path, artist)
        if os.path.exists(artist_path):
            for root, dirs, files in os.walk(artist_path):
                for file in files:
                    if file.endswith(".mp3"):
                        all_tracks.append(os.path.join(root, file).replace(albums_path, "/stream"))
        selected_tracks = all_tracks

    elif mode == "album":
        # Get all tracks from the selected album
        album_path = os.path.join(albums_path, artist, album)
        if os.path.exists(album_path):
            for file in os.listdir(album_path):
                if file.endswith(".mp3"):
                    all_tracks.append(os.path.join(album_path, file).replace(albums_path, "/stream"))
        selected_tracks = all_tracks

    return {"queue": selected_tracks}

@app.route("/get_albums", methods=["GET"])
def get_albums():
    artist = request.args.get("artist", "")
    artist_path = os.path.join(albums_path, artist)
    albums = []

    if os.path.exists(artist_path):
        albums = [folder for folder in os.listdir(artist_path) if os.path.isdir(os.path.join(artist_path, folder))]

    return {"albums": albums}


@app.route("/player", methods=["GET"])
def player():
    # Get the artist names and their folders
    artists = sorted([artist for artist in os.listdir(albums_path) if not artist.startswith(".")])

    # Pass the list of artists to the template
    return render_template("player.html", artists=artists)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')