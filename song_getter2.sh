#!/bin/bash
echo "Song Getter 2.0"

artist=$1
source=$2
isNew=0
 
echo " checking: $1"

#check if an artist exists
if [ -d "/media/pi/BE4B-8D55/Music/$1" ] 
then
    echo "This artist already exists" 
    isNew=0
else
    echo "$1 is a new Artist, Creating new Directory"
    isNew=1
    
    
    mkdir /media/pi/BE4B-8D55/Music/$artist
    
fi
#move to temp folder for extraction
 cd /media/pi/BE4B-8D55/Temp

 #extract the file
 youtube-dl -x -i --audio-format mp3  $2
 
 
echo "********** Extraction complete *********"
echo " Cleaning Files... " 
 

FILES=/media/pi/BE4B-8D55/Temp/*
echo "files: "
echo $Files

#loop through each track to clean
for f in $FILES
do
  

  #remove the .webm files
  #if grep -q .w



  song_title=${f::-16}

  new_name="${song_title}.mp3"


  echo "Renaming file to : $new_name"
  
  mv -- "$f" "$new_name"
  
 
done

mv  /media/pi/BE4B-8D55/Temp/* /media/pi/BE4B-8D55/Music/$1

ls /media/pi/BE4B-8D55/Music/$artist

echo " ****** Finished Download Successfully ************"






