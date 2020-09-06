#!/bin/sh
case "$(hostname)" in
    localhost)
        termux-notification \
            --title "$(m current --short)" \
            --content "Up next: $(m c | tail -1)" \
            --type media \
            --alert-once \
            --id 1 \
            --on-delete "echo cycle pause | socat - ~/.cache/mpvsocket_cache"\
            --media-next "echo playlist-next | socat - ~/.cache/mpvsocket_cache"\
            --media-pause "echo cycle pause | socat - ~/.cache/mpvsocket_cache"\
            --media-play "echo cycle pause | socat - ~/.cache/mpvsocket_cache"\
            --media-previous "echo playlist-prev | socat - ~/.cache/mpvsocket_cache"

        ;;
    *)
        pkill -10 -x lemon
        ;;
esac
:
