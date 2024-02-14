#!/bin/bash

mapfile -t outputs < <(hyprctl monitors -j | jq 'map("--output " + .name) | .[]' -r)
pkill -x lemon
RUST_LOG=${RUST_LOG:-debug} lemon --program zelbar ${outputs[@]} "$@" &>/tmp/$(whoami)/lemon.log
