#!/bin/bash
# Launches the music player controled using [m](./spells/m.spell)

m gui play-interactive
command -v jukebox && { pgrep jukebox ||
    pgrep youtube ||
    while :; do
        jukebox --room "$(hostname)" jukebox
        [[ ! "$i" ]] && i=0
        sleep "$((i++))"m
    done
}
