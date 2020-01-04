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
        vidlist="$vidlist
clipboard"
        vidname="$(echo "$vidlist" \
            | awk -F'\t' '{print $1}' \
            | dmenu -i -p "Which video?" -l "$(echo "$vidlist" | wc -l)")"

        if [ "$vidname" = "clipboard" ]
        then
            vids="$(xclip -sel clip -o)"
        else
            vids="$(echo "$vidlist" \
                | grep -F "$vidname" \
                | awk -F'\t' '{print $2}')"
        fi
        ;;

    shuf)
        vids="$(echo "$vidlist" \
            | shuf \
            | sed '1q' \
            | awk -F'\t' '{print $2}')"
        ;;

    shufA)
        tmp=$(echo "$vidlist" | shuf)
        vids="$(echo "$tmp" | awk -F'\t' '{print $2}' | xargs)"
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
        vids="$(echo "$vidlist" \
            | grep -P ".*\t.*\t.*\t.*$catg" \
            | awk -F'\t' '{print $2}' \
            | xargs)"
        ;;

    *)
        exit
        ;;
esac

[ -z "$vids" ] && exit

if [ "$(mpvsocket)" != "/dev/null" ]
then
    for song in $vids
    do
        m queue "$song" --notify
    done
else
    p=$(echo "no
yes" | dmenu -i -p "With video?")

    rm -f "$(mpvsocket new)_last_queue"
    case $p in
        yes)
            ( sleep 5; __update_panel; ) &
            #shellcheck disable=2086
            mpv --input-ipc-server="$(mpvsocket new)" $vids
            __update_panel
            ;;

        no)
            resolve_alias="$(command -v __update_panel | cut -d\' -f2)"
            cmd="(sleep 2; $resolve_alias) &
            mpv --input-ipc-server='$(mpvsocket new)' --no-video $vids
            $resolve_alias;"
            termite --class 'my-media-player' -e "bash -c '$cmd'"
            ;;
    esac
fi

