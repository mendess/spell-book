#!/bin/bash
image=$(ls -1 /home/mendes/Pictures/Wallpapers/ | shuf -n1)
gsettings set org.gnome.desktop.background picture-uri file:///home/mendes/Pictures/Wallpapers/$image
if (( $? != 0 ))
then
    echo -e "\033[31m"$image"\033[0m"
fi
