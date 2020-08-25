#!/bin/sh
%% switch on hostname
%% localhost {
CURRENT="$(m current \
    | head -2 \
    | tail -1 \
    | cut -d ':' -f2 \
    | sed '
    s/　/  /g;
    s/Ａ/A /g;
    s/Ｃ/C /g;
    s/Ｈ/H /g;
    s/Ｉ/I /g;
    s/Ｌ/L /g;
    s/Ｍ/M /g;
    s/Ｎ/N /g;
    s/Ｔ/T /g;
    s/Ｕ/U /g;' |
    sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

termux-notification --type media \
    --alert-once \
    --id 1 \
    --title "$CURRENT" \
    --media-next "echo playlist-next | socat - ~/.cache/mpvsocket_cache"\
    --media-pause "echo cycle pause | socat - ~/.cache/mpvsocket_cache"\
    --media-play "echo cycle pause | socat - ~/.cache/mpvsocket_cache"\
    --media-previous "echo playlist-prev | socat - ~/.cache/mpvsocket_cache"
%% }
%% default {
pkill -10 -x lemon
%% }
%% end
:
