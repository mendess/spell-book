#!/bin/sh

. library

cd "$(dirname "$(realpath "$0")")" || exit 1

access_token=""
.  ./yt_auth.sh

[ -z "$access_token" ] && echo "No access_token" && exit 1

search="$(echo "$*" | tr '[:upper:]' '[:lower:]')"
videoId="$(awk -F'\t' 'tolower($1) ~ /'"$search"'/ {print $2}' "$PLAYLIST" | awk -F'/' '{print $(NF)}')"

id=$(curl  'https://www.googleapis.com/youtube/v3/playlistItems?part=id&playlistId='"$PLAYLIST_ID"'&videoId='"$videoId"'&key='"$API_KEY" \
    --header 'Authorization: Bearer '"$access_token" \
    --header 'Accept: application/json' \
    --compressed \
    | jq -r '.items[0].id')

if [ -z "$id" ]
then
    echo Video not found
    exit 1
fi
curl --request DELETE \
    'https://www.googleapis.com/youtube/v3/playlistItems?id='"$id"'&key='"$API_KEY" \
    --header 'Authorization: Bearer '"$access_token" \
    --header 'Accept: application/json' \
    --compressed
