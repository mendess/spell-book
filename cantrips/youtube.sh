#!/bin/bash
# Launches the music player controled using [m](./spells/m.spell)

m gui play-interactive
command -v jukebox && { pgrep jukebox || while :; do jukebox --room tolaria jukebox; done; }
