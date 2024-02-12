#!/bin/bash

mapfile -t outputs < <(wlr-randr | awk '$0 ~ /^[^ ]/ { print("--output"); print($1) }')
pkill -x lemon
RUST_LOG=info lemon --program zelbar "${outputs[@]}"
