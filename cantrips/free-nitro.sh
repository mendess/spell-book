#!/usr/bin/env bash

LIST="${XDG_CONFIG_HOME:-~/.config}/free-nitro-list"

height=$(wc -l <"$LIST")
emoji=$(cut -d: -f1 "$LIST" | dmenu -l "$height" -p "Emoji")
[ "$emoji" ] || break
grep "$emoji" "$LIST" | cut -d: -f2- | xclip -sel clip
