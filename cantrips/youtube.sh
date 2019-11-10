#!/bin/bash

#shellcheck source=/home/mendess/.local/bin/library
. library

MODES="single
shuf
shufA
shufC"

mode=$(echo "$MODES" | dmenu -i -p "Mode?" -l "$(echo "$MODES" | wc -l)")

vidlist=$(sed '/^$/ d' "$PLAYLIST")

case "$mode" in
    single)
        vidname="$(echo "$vidlist" \
            | awk -F'\t' '{print $1}' \
            | dmenu -i -p "Which video?" -l "$(echo "$vidlist" | wc -l)")"

        vid=("$(echo "$vidlist" \
            | grep -P "^$vidname" \
            | awk -F'\t' '{print $2}')")

        ;;
    shuf)
        mapfile vid < <(echo "$vidlist" \
            | shuf \
            | sed '1q' \
            | awk -F'\t' '{print $2}')

        ;;
    shufA)
        tmp=$(echo "$vidlist" | shuf)
        mapfile vid < <(echo "$tmp" | awk -F'\t' '{print $2}' | xargs)
        ;;
    shufC)
        catg=$(echo "$vidlist" \
            | awk -F'\t' '{for(i = 4; i <= NF; i++) { print $i } }' \
            | tr '\t' '\n' \
            | sed '/^$/ d' \
            | sort \
            | uniq -c \
            | dmenu -i -p "Which category?" -l 30 \
            | sed -E 's/^[ ]*[0-9]*[ ]*//')
        [ -z "$catg" ] && exit
        vidlist=$(echo "$vidlist" | shuf)
        mapfile vid < <(echo "$vidlist" \
            | grep -P ".*\t.*\t.*\t.*$catg" \
            | awk -F'\t' '{print $2}' \
            | xargs)
        ;;
    *)
        exit
        ;;
esac

[ "${#vid}" -lt 1 ] && exit

p=$(echo "no
yes" | dmenu -i -p "With video?")

case $p in
    yes)
        {
            sleep 5
            __update_i3blocks
        } &
        mpv --input-ipc-server="$(mpvsocket new)" "${vid[@]}"
        __update_i3blocks
        ;;
    no)
        resolve_alias="$(command -v __update_i3blocks | cut -d\' -f2)"
        cmd="(sleep 2; $resolve_alias) &
        mpv --input-ipc-server='$(mpvsocket new)' --no-video ${vid[*]}
        $resolve_alias;"
        termite --title 'my-media-player' -e "bash -c '$cmd'"
        ;;
esac
