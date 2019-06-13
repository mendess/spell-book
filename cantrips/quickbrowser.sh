#!/bin/bash
spelldir="${0%/*}/.."
# shellcheck source=/home/mendess/Projects/spell-book/library.sh
. "$spelldir"/library.sh

nlines="$(wc -l "$BOOKMARKS" | cut -d' ' -f1)"
link="$(dmenu -i -p "Where should I go?" -l "$nlines" < "$BOOKMARKS")"
if [ "$link" != "" ]; then
    surf "$link"
fi
