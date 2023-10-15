#!/bin/bash

# Launch steam games from /comfy/ dmenu/fzf/tofi

steam_libraries=(
    ~/.local/share/Steam
    ~/.disks/ssd/media/games/Steam
    ~/.disks/hdd/SteamLibrary
    ~/.disks/nvme/media/games/steam
)
acfs=()
for path in "${steam_libraries[@]}"; do
    acfs+=("$path/steamapps/"*acf)
done

games="$(grep -Hn "name" "${acfs[@]}" |
    sed -E 's|'"$HOME"'/?(.*)/[^/]+/steamapps/appmanifest_([0-9]+)\.acf.*"name".*"([^"]+)"|~/\1\t\2\t\3|g' |
    sed 's/Counter.*/Dust II/' |
    sed -r 's/[0-9]+\s//' |
    grep -viE 'proton|redistributable|linux')"

[[ "$spit" ]] && echo "$games" && exit

name="$(echo "$games" |
    column -ts$'\t' |
    picker \
    -i \
    -l "$(echo "$games" | wc -l)" \
    -p "dsteam" \
    -nb "#2c323b" \
    -nf "#c5cbd8" \
    -sb "#3e4e69" \
    -sf "#ffffff" |
    cut -d' ' -f2- |
    sed -E 's/^ +//;s/ +$//')"

[ -n "$name" ] || exit

echo "searching for $name"

game=$(echo "$games" | tee /dev/tty | grep "$name" | cut -d$'\t' -f2)
steam "steam://run/$game"
