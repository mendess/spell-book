#!/bin/bash
# shellcheck source=/home/mendess/.local/bin/library
. library

nlines="$(wc -l "$BOOKMARKS" | cut -d' ' -f1)"
link="$(dmenu -i -p "Where should I go?" -l "$nlines" < "$BOOKMARKS")"
if [ "$link" != "" ]; then
    surf "$link"
fi
