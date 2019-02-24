#!/bin/bash

link="$(cat bookmarks | dmenu -i -p "Where should I go?" -l $(wc -l bookmarks | cut -d' ' -f1))"
if [ "$link" != "" ]; then
    surf "$link"
fi
