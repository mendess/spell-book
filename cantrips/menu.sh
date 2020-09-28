#!/bin/bash
set -x
exec &> ~/lmao
echo "$0"
cd "$(dirname "$(realpath "$0")")" || exit 1
pwd

[ "$1" = GUI ] && picker=dmenu || picker=fzf

./"$(find . -name '*.sh' -executable |
    grep -v 'menu' |
    sed 's|./||g;s/\.sh$//g' |
    sort -r |
    PICKER=$picker picker -i -p "Pick a menu:" -l 100)".sh "$1" &
disown
