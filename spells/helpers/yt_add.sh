#!/bin/bash

. library

cd "$(dirname "$(realpath "$0")")" || exit 1

access_token=""
. ./yt_auth.sh

[ -z "$access_token" ] && echo "No access_token" && exit 1

curl --request POST \
    'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&key='"$API_KEY" \
    --header 'Authorization: Bearer '"$access_token" \
    --header 'Accept: application/json' \
    --header 'Content-Type: application/json' \
    --data '{"snippet":{"playlistId":"'"$PLAYLIST_ID"'","resourceId":{"kind":"youtube#video","videoId":"'"$1"'"}}}' \
    --compressed

