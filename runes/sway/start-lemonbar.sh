#!/bin/bash

while :; do
    mapfile -t outputs < <(swaymsg -t get_outputs | grep '^Output' | awk '{print $2}')
    pkill -x lemon
    RUST_LOG=${RUST_LOG:-debug} lemon --program zelbar "${outputs[@]}" "$@" &>"/tmp/$(whoami)/lemon.log"
done
