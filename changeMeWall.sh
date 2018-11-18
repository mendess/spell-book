#!/bin/bash

i=0
while [ "$i" -lt "$(xrandr --query | grep ' connected' | wc -l)" ]; do
    nitrogen --set-zoom-fill --random --head="$i" ~/Pictures/Wallpapers
    i=$(($i + 1))
done
