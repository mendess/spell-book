#!/bin/bash
# The menu used to find and launch the cantrips

cd "$(dirname "$(realpath "$0")")" || exit 1

./??-"$(find . -name '*.sh' -executable |
    grep -v 'menu' |
    sort |
    sed -E 's|^./[0-9][0-9]-||; s/\.sh$//;' |
    picker  \
        -i \
        -p "Pick a menu:" \
        -l 5)".sh "$1"
