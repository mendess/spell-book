#!/bin/sh

env_file=/tmp/env

var="$(cat "$env_file" | cut -d= -f1 | dmenu -i -l $(wc -l < "$env_file"))"

[ "$var" ] || exit 0


cat "$env_file" | grep "$var" | cut -d= -f2 | xclip -sel clip -r
