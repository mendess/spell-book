#!/bin/sh

cwd="$(pwd)"
cd /tmp
git clone https://github.com/abba23/spotify-adblock-linux.git
cd spotify-adblock-linux
make
mv spotify-adblock.so ~/.local/bin/
cd "$cwd"

