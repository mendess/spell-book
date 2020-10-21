#!/bin/bash

bash -x m gui play-interactive
command -v jukebox && { pgrep jukebox || while :; do jukebox --room tolaria jukebox; done; }
