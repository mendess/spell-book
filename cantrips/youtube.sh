#!/bin/bash

m gui play-interactive
pgrep jukebox || while :; do jukebox --room tolaria jukebox; done
