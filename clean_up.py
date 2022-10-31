import mutagen
from mutagen.easyid3 import EasyID3
from mutagen.mp3 import EasyMP3
from mutagen.mp3 import MP3

print("Cleaning up  MP3s....")

keys = mutagen.File("Durand Jones & The Indications - Love Will Work It Out (Official Video)-2AnXiScwWj4.mp3").keys()
print(keys)
#f = MP3("Durand Jones & The Indications - Love Will Work It Out (Official Video)-2AnXiScwWj4.mp3", ID3=EasyID3)
#print(f.info)
# for key in keys:
    
#     print(key)

tags = EasyMP3("Durand Jones & The Indications - Love Will Work It Out (Official Video)-2AnXiScwWj4.mp3")


tags["title"] = "Love Will Work It Out"
tags.save()
for tag in tags:
    print(tag)



print("File(s) Clean")