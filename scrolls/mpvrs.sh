#!/bin/sh

mkdir -p "$HOME"/.config/mpv/scripts
curl 'https://raw.githubusercontent.com/noaione/mpv-discordRPC/master/Scripts/mpv-drpc.lua' \
    > "$HOME"/.config/mpv/scripts/mpv-drpc.lua

sudo wget 'https://github.com/noaione/mpv-discordRPC/raw/master/lib/linux/libdiscord-rpc.so' \
    -O /usr/local/lib/libdiscord-rpc.so
