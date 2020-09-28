#!/bin/bash
case "$(hostname)" in
    localhost)
        m="$(m c | awk 'NR > 1 && NR < 4 {print} {last=$0} END {print last}')"
        title="$(echo "$m" | sed 2q)"
        content="$(echo "$m" | tail -1)"
        termux-notification \
            --title "$title" \
            --content "Up next: $content" \
            --type media \
            --alert-once \
            --id 1 \
            --on-delete "echo '{ \"command\": [\"set_property\", \"pause\", true] }' |\
                socat - ~/.cache/mpvsocket_cache" \
            --media-next "echo playlist-next | socat - ~/.cache/mpvsocket_cache"\
            --media-pause "echo cycle pause | socat - ~/.cache/mpvsocket_cache"\
            --media-play "echo cycle pause | socat - ~/.cache/mpvsocket_cache"\
            --media-previous "echo playlist-prev | socat - ~/.cache/mpvsocket_cache"

        ;;
    *)
        pkill -10 -x lemon
        ;;
esac
