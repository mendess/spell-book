#!/bin/bash

pkgs=( numlockx rxvt-unicode urxvt-perls ttf-dejavu scrot xcompmgr nitrogen feh alsa-utils firefox xclip xorg-server xorg-init nm-applet )

aurpkgs=( dropbox discord )

i3pkgs=( i3-gaps i3status i3lock dmenu )

sudo pacman -S --noconfirm "${pkgs[@]}"
yaourt --m-arg "--skippgpcheck" "${aurpkgs[@]}"
echo "exec i3" > ~/.xinitrc
sudo pacman -S --noconfirm "${i3pkgs[@]}"
../castRunes.sh
