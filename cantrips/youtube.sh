#!/bin/bash

MODES="single
shuf
shufA
shufC"

mode=$(echo "$MODES" | dmenu -i -p "Mode?" -l "$(echo "$MODES" | wc -l)")

vidlist=$(sed '/^$/ d' links)

case "$mode" in
    single)
        vidname="$(echo "$vidlist" \
            | awk -F'\t' '{print $1}' \
            | dmenu -i -p "Which video?" -l "$(echo "$vidlist" | wc -l)")"

        vid="$(echo "$vidlist" \
            | grep -P "^$vidname" \
            | awk -F'\t' '{print $2}')"

        title="$vidname"
        ;;
    shuf)
        vid=$(echo "$vidlist" \
            | shuf \
            | sed '1q' \
            | awk -F'\t' '{print $2}')

        title=$(echo "$vidlist" \
            | grep "$vid" \
            | awk -F'\t' '{print $1}')

        ;;
    shufA)
        tmp=$(echo "$vidlist" | shuf)
        vid=$(echo "$tmp" | awk -F'\t' '{print $2}' | xargs)
        title="$(echo "$tmp" | awk -F'\t' '{print $1}')"
        ;;
    shufC)
        catg=$(echo "$vidlist" \
            | awk -F'\t' '{for(i = 3; i <= NF; i++) { print $i } }' \
            | tr '\t' '\n' \
            | sed '/^$/ d' \
            | sort \
            | uniq -c \
            | dmenu -i -p "Which category?" \
            | sed -E 's/^[ ]*[0-9]*[ ]*//')

        vid="$(echo "$vidlist" | grep -P ".*\t.*\t.*$catg" | awk -F'\t' '{print $2}' | xargs)"
        title="$(echo "$vidlist" | grep -P ".*\t.*\t.*$catg" | awk -F'\t' '{print $1}')"
        ;;
esac

[ "$vid" = "" ] && exit

p=$(echo "no
yes" | dmenu -i -p "With video?")

case $p in
    yes)
        # shellcheck disable=SC2086
        mpv --input-ipc-server=/tmp/mpvsocket $vid
        ;;
    no)
        cmd="echo -e '\n$title'; mpv --input-ipc-server=/tmp/mpvsocket --no-video $vid"
        urxvt -fn "xft:DejaVu Sans Mono:autohint=true:size=20" -title 'my-media-player' -e bash -c "$cmd"
        ;;
esac
