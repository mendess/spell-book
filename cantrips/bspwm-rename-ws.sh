#!/bin/bash
[ "$1" = GUI ] && picker=dmenu || picker=fzf
WSNUM=$(bspc query -D -d --names)
NEW=$(echo "" | PICKER="$picker" picker -p "Enter new ws name:")
bspc desktop --rename "$WSNUM $NEW"
