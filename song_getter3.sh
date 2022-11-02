#!/bin/bash
echo "Song Getter 1.3"

source=$1
isNew=0
music_path="/media/pi/3234-3964/tempbackup/"


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

 
 


 cd "$music_path$artist_name_with_spaces"
 pwd

 echo $1
 
 youtube-dl -x -i --write-thumbnail --audio-format mp3  $1
 
music_files="$music_path$artist_name_with_spaces"*


#for f in $FILES
#do
  
  #file_name="${f##*/}"

  
  #song_title=$(echo $file_name | cut -d'(' -f 1 )
  #extension=".mp3"
  
  #new_name=${song_title%?}$extension
  
  
  
  #new_name=${new_name// /_}
  #echo "Renaming file to : $new_name"
  
  #mv -- "$f" "$new_name"
 
#done