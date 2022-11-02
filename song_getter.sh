#!/bin/bash
echo "Song Getter 1.0"

artist=$1
source=$2
isNew=0
 
echo " checking: $1"


#check for parameters


#check if an artist exists
if [ -d "/media/pi/3234-3964/Music/$1" ] 
then
    echo "This artist already exists" 
    isNew=0
else
    echo "$1 is a new Artist, Creating new Directory"
    isNew=1
    
    
    mkdir /media/pi/3234-3964/tempbackup/$artist
    
fi

 cd /media/pi/3234-3964/tempbackup/$artist
 
 youtube-dl -x -i --write-thumbnail --audio-format mp3  $2
 
 
echo "********** Extraction complete *********"
echo " Cleaning Files... " 


FILES=/media/pi/EMTEC/Music/$artist/*


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

ls /media/pi/3234-3964/tempbackup/$artist

echo " ****** Finished Download Successfully ************"


#dir=$(pwd)

#find $dir -name '*.mp3' -exec mv {} /media/pi/EMTEC/Music/Led_Zepplin/ \;


#for i in $dir
 #do 
 #mv -- "$i" "/media/pi/EMTEC/Music/Led_Zepplin/" 
 #done



