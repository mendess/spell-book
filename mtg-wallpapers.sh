#!/bin/bash
mkdir -p /tmp/walls
cd /tmp/walls
rm -f *

curl -s https://magic.wizards.com/en/articles/media/wallpapers | grep '1920x1080' | cut -d'=' -f2 | cut -d'"' -f2 | xargs wget

for f in *
do
    mv $f "$HOME/Pictures/Wallpapers/"$(echo $f | sed 's/_..._1920x1080_Wallpaper//')
done
