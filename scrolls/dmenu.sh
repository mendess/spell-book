#!/bin/bash

sudo pacman -Rdd dmenu

cd /tmp || exit
git clone https://github.com/mendess/dmenu
cd dmenu || exit
sudo make install
cd /tmp || exit
rm -rf dmenu
