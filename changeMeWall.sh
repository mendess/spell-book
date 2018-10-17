#!/bin/bash

if [[ $DESKTOP_SESSION == "i3" ]]
then
    nitrogen --set-zoom-fill --random ~/Pictures/Wallpapers
else
    image=$(ls -1 /home/mendess/Pictures/Wallpapers/ | shuf -n1)
    gsettings set org.gnome.desktop.background picture-uri file:///home/mendess/Pictures/Wallpapers/$image 2> ~/wallerror.log
    if (( $? != 0 ))
    then
        echo -e "\033[31m"$image"\033[0m"
    else
        echo "Error: $image" 2> ~/wallerror.log
    fi
fi
