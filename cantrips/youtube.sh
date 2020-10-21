#!/bin/bash

m gui play-interactive
command -v jukebox && { pgrep jukebox || while :; do jukebox --room tolaria jukebox; done; }
