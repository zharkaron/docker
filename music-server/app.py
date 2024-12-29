from flask import Flask, jsonify, render_template, send_from_directory, request
import os
import random

app = Flask(__name__)

# Music Directory
MUSIC_FOLDER = "music"
music_files = [f for f in os.listdir(MUSIC_FOLDER) if f.endswith((".mp3", ".wav"))]
played_songs = []

def shuffle_songs():
    global played_songs
    # If all songs have been played, reset
    if len(played_songs) == len(music_files):
        played_songs = []
    # Find unplayed songs and select one randomly
    remaining_songs = list(set(music_files) - set(played_songs))
    song = random.choice(remaining_songs)
    played_songs.append(song)
    return song

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/play-next", methods=["POST"])
def play_next():
    song = shuffle_songs()
    return jsonify({"current_song": song})

@app.route("/current-song", methods=["GET"])
def current_song():
    return jsonify({"current_song": played_songs[-1] if played_songs else "No song playing"})

@app.route("/music/<filename>")
def serve_music(filename):
    return send_from_directory(MUSIC_FOLDER, filename)

# Main Runner
if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')

