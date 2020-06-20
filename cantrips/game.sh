#!/bin/sh

# Launch steam games from /comfy/ dmenu

[ "$1" = GUI ] && picker=dmenu || picker=fzf

games="$(grep -n "name" ~/.local/share/Steam/steamapps/*.acf ~/.hdd/SteamLibrary/steamapps/*acf \
    | sed -E 's/.*appmanifest_([0-9]+)\.acf.*"name".*"([^"]+)"/\1\t\2/g')"

name="$(echo "$games" | sed -r 's/[0-9]+\s//' | grep -v -i -E 'proton|redistributable' | \
    PICKER="$picker" picker \
    -i \
    -l "$(echo "$games" | wc -l)" \
    -p "dsteam" \
    -nb "#2c323b" \
    -sb "#c5cbd8" \
    -sb "#3e4e69" \
    -sf "#ffffff")"

[ -n "$name" ] || exit
echo "$games" | grep "$name" | awk -F'\t' '{print $1}' | xargs -I{} steam 'steam://run/{}'
killall steam
