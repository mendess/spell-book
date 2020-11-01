#!/bin/bash
# Launches vimb with one of the [bookmarks](./library/bookmarks)

nlines="$(wc -l < "$BOOKMARKS")"
link="$(cut -d',' -f1  "$BOOKMARKS" | dmenu -i -p "Where should I go?" -l "$nlines")"
if [ "$link" != "" ]; then
    if grep -F "$link" "$BOOKMARKS" | grep main ; then
        "$BROWSER" "$link"
    else
        vimb "$link"
    fi
fi
