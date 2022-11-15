#!/bin/bash


cleanup_path="/media/pi/3234-3964/Music/"
cd $cleanup_path
pwd

for d in *; do  
    if [ -d "$d" ] ; then
    echo "$d"
    filename="$d"
    final=${filename//[_]/" "}
    echo "$final"

    mv -- "$d" "$final"
    fi
done