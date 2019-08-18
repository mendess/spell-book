#!/bin/bash
cd "$(dirname "$(realpath "$0")")" || exit 1

./"$(find . | grep -v 'menu' | grep '\.sh' | sed -e 's|./||g' -e 's/\.sh$//g' | sort -r | dmenu -i -p "Pick a menu:" -l 5)".sh &
diswon
