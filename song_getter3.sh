#!/bin/bash
echo "Song Getter 1.3"

source=$1
isNew=0
music_path="/media/pi/SAMSUNG-USB/Music/"
temp_path="/media/pi/SAMSUNG-USB/Temp"

# if [[ -z $1 ]]
# then
#   echo "Need to enter a youtube link: song_getter3.sh source_url artist"
# else
#   echo "parameter 1: $1"

# fi

# if [[ -z $2 ]]
# then
#   echo "Enter an artist"
# else
#   echo "Artist: $2"

# fi


artist_name=""
i=$(($#-2))
while [ $i -ge 0 ]
do   echo ${BASH_ARGV[$i]}
     artist_name="$artist_name ${BASH_ARGV[$i]}"
     i=$((i-1))
     
done

#remove the empty space at front of string
artist_name_with_spaces="${artist_name:1}"
echo "$artist_name_with_spaces"
 
if [ -d "$music_path$artist_name_with_spaces" ] 
then
    echo "This artist already exists" 
    isNew=0
else
    echo "$artist_name_with_spaces is a new Artist, Creating new Directory"
    isNew=1

    mkdir $music_path"$artist_name_with_spaces"
fi

 
 


 #cd "$music_path$artist_name_with_spaces"
 pwd 

#change to temp folder:
cd "$temp_path"

dir=$(pwd)
echo $dir
 echo $1
 
 #youtube-dl -x -i --yes-playlist --verbose --audio-format mp3  $1
 yt-dlp -x -i --yes-playlist --verbose --audio-format mp3  $1
music_files="$music_path$artist_name_with_spaces"

shopt -s globstar

echo "Cleaning file names"

for f in ./**
do

 file_name="${f##*/}"

 echo "filename --> "$file_name
  
if [[ $file_name == *"webp"* ]]
then
  rm "$f"


fi

if [[ $file_name == *"webm"* ]]
then
  rm "$f"


fi

if [[ $file_name == *"mp3"* ]]; then
  echo "found an mp3!"

   # song_title=$(echo $file_name | cut -d'(' -f 1 )



  #song_title=$(echo $file_name | rev | cut -c17- | rev)

  song_title=$(echo $file_name |sed 's/(Official video)//' | rev | cut -c16- | rev)

  # song_title= echo $file_name | awk '{ print substr( $0, 1, length($0)-16 ) }' 
  extension=".mp3"

  

  $song_title="${song_title//_}"

  echo "new song title: "$song_title 

  
  new_name=${song_title%?}$extension
  
  
  
  #$new_name=${new_name// /_}
  echo "Renaming file to : $new_name"
  echo "to location: $music_path$artist_name_with_spaces/$new_name"
  pwd
  mv -- "$f" "$music_path$artist_name_with_spaces/$new_name"




fi


#  echo "file >> $f" 

#   file_name="${f##*/}"

#   filename=$(basename ./**)

#   echo $filename
#   echo "Filename:  ${filename%.*}"
  
#   song_title=$(echo $file_name | cut -d'(' -f 1 )
#   extension=".mp3"
  
#   new_name=${song_title%?}$extension
  
  
  
#   new_name=${new_name// /_}
#   echo "Renaming file to : $new_name"
  
#   mv -- "$f" "$new_name"
 
done


ls

echo " ****** Finished Download Successfully ************"

echo " Cleaning up..."


