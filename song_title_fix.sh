#!/bin/bash
echo "Song Title cleaner....."


#print all the songs

ARTISTS=/media/pi/BE4B-8D55/Music/*

for artist in $ARTISTS
do

echo $artist


    for song in $artist/*
    do

    
    echo "${song##*/}"
    song_title=${song::-16}

    new_name="${song_title}.mp3"

    mv -- "$song" "$new_name"
     
    done


done