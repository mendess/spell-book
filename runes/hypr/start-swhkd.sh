#!/bin/bash

log=/tmp/$(whoami)/swhkd.log
mkdir -p "$(dirname "$log")"
exec &>"$log"

swhks &
swhkd \
    --cooldown 400 \
    --log "${XDG_RUNTIME_DIR:-$HOME/.local/share}/swhks-current_unix_time.log"
