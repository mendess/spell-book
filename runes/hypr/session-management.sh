#!/bin/bash

kill-hypr() {
    if pgrep -x Hyprland >/dev/null; then
        hyprctl dispatch exit 0
        sleep 2
        if pgrep -x Hyprland >/dev/null; then
            pkill -9 Hyprland
        fi
    fi
    [[ "$1" ]] && "$@"
}

opt=$(printf 'lock\nsuspend\nreboot\nshutdown\n' | picker -nb '#6b0213' -sb '#a8031e' -nf '#FFFFFF' -sf '#FFFFFF' -l 4)
case "$opt" in
    lock)
        CACHE=${XDG_CACHE_HOME:-~/.cache}/changeMeWall
        c1=$(cat "${CACHE}/wall_colors" | sed -n 1p | cut -d' ' -f1 | sed 's/#//')
        c1_t=$(cat "${CACHE}/wall_colors" | sed -n 1p | cut -d' ' -f2 | sed 's/#//')
        c2=$(cat "${CACHE}/wall_colors" | sed -n 2p | cut -d' ' -f1 | sed 's/#//')
        c3=$(cat "${CACHE}/wall_colors" | sed -n 3p | cut -d' ' -f1 | sed 's/#//')
        dunstctl set-paused true
        SESSION_KIND=cli m set-pause > /dev/null
        swaylock --inside-clear-color="$c1" --text-clear-color="$c1_t" --ring-clear-color="$c3"
                 --inside-ver-color="$c1"   --text-ver-color="$c1_t"   --ring-ver-color="$c3"
                 --ring-color="$c3" --key-hl-color="$c2"
        dunstctl set-paused false
    ;;
    suspend) systemctl suspend ;;
    reboot) kill-hypr reboot ;;
    shutdown) kill-hypr shutdown now ;;
esac

