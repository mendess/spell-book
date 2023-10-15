#!/usr/bin/env bash
# I don't feel like paying discord, so I just store emoji gifs and quickly copy
# them to the clipboard to paste in chat. 😎

LIST="${XDG_CONFIG_HOME:-~/.config}/free-nitro-list"

height=$(wc -l <"$LIST")
emoji=$(cut -d: -f1 "$LIST" | picker -l "$height" -p "Emoji")
[ "$emoji" ] || break
grep "$emoji" "$LIST" | cut -d: -f2- | xclip -sel clip
