#!/bin/bash
# shellcheck source=/home/mendess/.local/bin/library
. library

nlines="$(wc -l < "$BOOKMARKS")"
link="$(cut -d',' -f1  "$BOOKMARKS" | dmenu -i -p "Where should I go?" -l "$nlines")"
if [ "$link" != "" ]; then
    if grep -F "$link" "$BOOKMARKS" | grep main ; then
        "$BROWSER" "$link"
    else
        vimb "$link"
    fi
fi
