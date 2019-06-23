#!/bin/bash
eval "$(library)"

nlines="$(wc -l "$BOOKMARKS" | cut -d' ' -f1)"
link="$(dmenu -i -p "Where should I go?" -l "$nlines" < "$BOOKMARKS")"
if [ "$link" != "" ]; then
    surf "$link"
fi
