#!/bin/bash
# Launches the music player controled using [m](./spells/m.spell)

set -x
m gui play-interactive
command -v jukebox && { pgrep jukebox ||
    [[ "$(pgrep youtube | wc -l)" -gt 2 ]] ||
    while :; do
        jukebox --room "$(hostname)" jukebox </dev/null
        [[ ! "$i" ]] && i=0
        sleep "$((i++))"m
    done
}
