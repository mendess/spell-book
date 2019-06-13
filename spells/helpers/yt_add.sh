#!/bin/bash

PLAYLIST_ID='PLMlpz9TVZoe-3bMPXLuRrnJmY7xcOe_6w'

spelldir="${0%/*}"

"$spelldir"/yt_auth.sh

curl --request POST \
    'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&key='"$API_KEY" \
    --header 'Authorization: Bearer '"$access_token" \
    --header 'Accept: application/json' \
    --header 'Content-Type: application/json' \
    --data '{"snippet":{"playlistId":"'$PLAYLIST_ID'","resourceId":{"kind":"youtube#video","videoId":"'"$1"'"}}}' \
    --compressed

