#!/bin/bash

exec &>/tmp/mendess/swhkd.log

swhks &
swhkd --cooldown 400 --log ${XDG_RUNTIME_DIR:-$HOME/.local/share}/swhks-current_unix_time.log
