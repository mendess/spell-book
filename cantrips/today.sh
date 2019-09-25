#!/bin/sh

title=$(calcurse -a | head -1)
notify-send "$title" "$(calcurse -a | tail +2)"
