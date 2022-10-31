song="Smolik - 50 Trees feat. Artur Rojek & Novika -sVWHh9SqooY.mp3"

echo $song

#song_title=$(echo $song | cut -d'(' -f 1 )

song_title=${song::-17}



song_title="${song_title}.mp3"

echo $song_title