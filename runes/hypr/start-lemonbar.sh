#!/bin/bash

mapfile -t outputs < <(hyprctl monitors -j | jq 'map("--output " + .name) | .[]' -r)
pkill -x lemon
RUST_LOG=${RUST_LOG:-info} lemon --program zelbar ${outputs[@]} "$@"
