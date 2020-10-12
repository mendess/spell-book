#!/bin/bash
[ "$1" = GUI ] && picker=dmenu || picker=fzf
WSNUM=$(bspc query -D -d --names | grep -oP '^[0-9]+')
NEW=$(echo "" | PICKER="$picker" picker -p "Enter new ws name:")
[[ "$NEW" ]] && bspc desktop --rename "$WSNUM $NEW"
