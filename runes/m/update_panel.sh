#!/bin/sh
%% switch on hostname
%% tolaria {
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
    --media-next "echo playlist-next | socat - '$SOCKET'"\
    --media-pause "echo cycle pause | socat - '$SOCKET'"\
    --media-play "echo cycle pause | socat - '$SOCKET'"\
    --media-previous "echo playlist-prev | socat - '$SOCKET'"
%% }
%% default {
pkill -10 -x lemon
%% }
%% end
:
