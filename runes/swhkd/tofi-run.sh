#!/bin/bash

wall_colors=/tmp/$LOGNAME/wall_colors
if [ -e "$wall_colors" ]; then
    first=$(cat /tmp/$LOGNAME/wall_colors | head -1 | cut -d' ' -f1) ; \
    first_text=$(cat /tmp/$LOGNAME/wall_colors | head -1 | cut -d' ' -f2) ; \
    second="$(cat /tmp/$LOGNAME/wall_colors | tail -1 | cut -d' ' -f1)AA" ; \
    second_text=$(cat /tmp/$LOGNAME/wall_colors | tail -1 | cut -d' ' -f2) ; \
else
    first='#6B97D0'
    first_text='#000000'
    second='#9F783AAA'
    second_text='#FFFFFF'
fi
tofi-run \
    --background-color "$second" \
    --text-color "$second_text" \
    --border-color "$first" \
    --selection-background "$first" \
    --selection-color "$first_text" | bash

