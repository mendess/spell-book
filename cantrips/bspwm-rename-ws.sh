#!/bin/bash
WSNUM=$(bspc query -D -d --names)
NEW=$(echo "" | dmenu -p "Enter new ws name:")
bspc desktop --rename "$WSNUM $NEW"
