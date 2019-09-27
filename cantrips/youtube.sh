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
            | awk -F'\t' '{for(i = 4; i <= NF; i++) { print $i } }' \
            | tr '\t' '\n' \
            | sed '/^$/ d' \
            | sort \
            | uniq -c \
            | dmenu -i -p "Which category?" -l 30 \
            | sed -E 's/^[ ]*[0-9]*[ ]*//')
        [ -z "$catg" ] && exit
        vid="$(echo "$vidlist" | grep -P ".*\t.*\t.*\t.*$catg" | awk -F'\t' '{print $2}' | xargs)"
        title="$(echo "$vidlist" | grep -P ".*\t.*\t.*\t.*$catg" | awk -F'\t' '{print $1}')"
        ;;
    *)
        exit
        ;;
esac

[ -z "$vid" ] && exit

p=$(echo "no
yes" | dmenu -i -p "With video?")

case $p in
    yes)
        {
            sleep 10
            eval "$UPDATE_I3BLOCKS"
        } &
        # shellcheck disable=SC2086
        mpv --input-ipc-server="$MPVSOCKET" $vid
        eval "$UPDATE_I3BLOCKS"
        ;;
    no)
        cmd="(sleep 2; $UPDATE_I3BLOCKS) &
        echo -e '\n$title'; mpv --input-ipc-server='$MPVSOCKET' --no-video $vid ; $UPDATE_I3BLOCKS"
        urxvt -title 'my-media-player' -e bash -c "$cmd" &
        disown
        ;;
esac
