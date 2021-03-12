#!/bin/sh

env_file=/tmp/env

if [ ! -f "$env_file" ]; then
    notify-send 'No env file' -u critical -a env
    exit 1
fi

var="$(cat "$env_file" | cut -d= -f1 | dmenu -i -l $(wc -l < "$env_file"))"

[ "$var" ] || exit 0


cat "$env_file" | grep "$var" | cut -d= -f2 | xclip -sel clip -r
