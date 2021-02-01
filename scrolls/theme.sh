#!/bin/sh
# Setup the artim-dark theme

wget https://github.com/Mrcuve0/Aritim-Dark/archive/master.zip
unzip master.zip
readonly themes_dir="$HOME"/.themes
mkdir -p "$themes_dir"
mv Aritim-Dark-master/GTK "$themes_dir"/ayu
rm -rf Aritim-Dark-master master.zip
