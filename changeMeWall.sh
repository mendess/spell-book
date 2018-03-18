#!/bin/bash
gsettings set org.gnome.desktop.background picture-uri file:///home/mendes/Pictures/Wallpapers/$(ls -1 /home/mendes/Pictures/Wallpapers/ | shuf -n1)
