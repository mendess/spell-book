#!/bin/bash
case "$(hostname)" in
    localhost)
        get() {
            echo '{ "command": ["get_property", "'"$1"'"] }' |
                socat - ~/.cache/mpvsocket_cache |
                jq .data -r
            }
        # export PATH=$PATH:~/.local/bin
        title="$(get media-title)"
        vol="$(get volume)"
        case "$(get pause)" in
            true) status="||" ;;
            false) status=">" ;;
        esac
        termux-notification \
            --title "$title" \
            --content "$status @ $vol%" \
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
