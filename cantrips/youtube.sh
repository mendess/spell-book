#!/bin/bash

#shellcheck source=/home/mendess/.local/bin/library
. library

if [[ -z "$DISPLAY" ]]; then
    if ! hash fzf; then
        echo 'Need X with dmenu or fzf to use'
        exit 1
    fi
fi

selector() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            -l)
                listsize="$2"
                shift
                ;;
            -p)
                prompt="$2"
                shift
                ;;
            *)
                shift
                ;;
        esac
    done
    if [ -z "$DISPLAY" ]; then
        fzf -i --prompt "$prompt"
    else
        dmenu -i -p "$prompt" -l "$listsize"
    fi
}

MODES="single
random
All
Category
clipboard"

mode=$(echo "$MODES" | selector -i -p "Mode?" -l "$(echo "$MODES" | wc -l)")

echo "$PLAYLIST"
vidlist=$(sed '/^$/ d' "$PLAYLIST")

case "$mode" in
    single)
        vidname="$(echo "$vidlist" \
            | awk -F'\t' '{print $1}' \
            | selector -i -p "Which video?" -l "$(echo "$vidlist" | wc -l)")"

        if [ -z "$vidname" ]; then
            exit 1
        else
            vids="$(echo "$vidlist" \
                | grep -F "$vidname" \
                | awk -F'\t' '{print $2}')"
        fi
        ;;

    random)
        vids="$(echo "$vidlist" \
            | shuf \
            | sed '1q' \
            | awk -F'\t' '{print $2}')"

        ;;

    All)
        tmp=$(echo "$vidlist" | shuf)
        vids="$(echo "$tmp" | awk -F'\t' '{print $2}' | xargs)"
        ;;

    Category)
        catg=$(echo "$vidlist" \
            | awk -F'\t' '{for(i = 4; i <= NF; i++) { print $i } }' \
            | tr '\t' '\n' \
            | sed '/^$/ d' \
            | sort \
            | uniq -c \
            | selector -i -p "Which category?" -l 30 \
            | sed -E 's/^[ ]*[0-9]*[ ]*//')

        [ -z "$catg" ] && exit
        vidlist=$(echo "$vidlist" | shuf)
        vids="$(echo "$vidlist" \
            | grep -P ".*\t.*\t.*\t.*$catg" \
            | awk -F'\t' '{print $2}' \
            | xargs)"

        ;;

    clipboard)
        clipboard=1
        vids="$(xclip -sel clip -o)"
        [ -n "$vids" ] || exit 1
        ;;
    *)
        exit
        ;;
esac

[ -z "$vids" ] && exit

if [ "$(mpvsocket)" != "/dev/null" ] || [ -z "$DISPLAY" ]; then
    p=no
else
    p=$(echo "no
yes" | selector -i -p "With video?")
fi

final_list=()
for v in $(echo "$vids" | shuf)
do
    PATTERN=(~/Music/*"$(basename "$v")"*)
    echo -n "PATTERNS: ${PATTERN[*]}"
    if [ -f "${PATTERN[0]}" ]
    then
        echo '  -> ' added as file
        final_list+=("${PATTERN[0]}")
    else
        echo '  -> ' added as link
        final_list+=("$v")
    fi
done

[ -n "$clipboard" ] || \
    (
        cd ~/Music || exit 1; \
        echo "${final_list[@]}" | grep '^http' | xargs --no-run-if-empty -L 1 youtube-dl --add-metadata &>/tmp/youtube-dl
    ) &

if [ "$(mpvsocket)" != "/dev/null" ]
then
    for song in "${final_list[@]}"
    do
        if [[ "$song" == *playlist* ]]; then
            for s in $(youtube-dl "$song" --get-id); do
                m queue "https://youtu.be/$s" --notify
            done
        else
            m queue "$song" --notify
        fi
    done
else
    rm -f "$(mpvsocket new)_last_queue"
    (
        sleep 2
        __update_panel
        sleep 8
        for file in "${final_list[@]:1}"
        do
            sleep 0.1
            m queue "$file"
        done
        m queue --reset
    ) &
    case $p in
        yes)
            mpv --input-ipc-server="$(mpvsocket new)" "${final_list[0]}"
            ;;

        no)
            if [ -z "$DISPLAY" ]; then
                mpv --input-ipc-server="$(mpvsocket new)" --no-video "${final_list[0]}"
            else
                $TERMINAL --class my-media-player -e mpv --input-ipc-server="$(mpvsocket new)" --no-video "${final_list[0]}" &
            fi
            ;;
    esac
fi
