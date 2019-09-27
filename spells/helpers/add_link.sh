#!/bin/bash
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <link>"
    exit 1
fi

cd "$(dirname "$(realpath "$0")")" || exit 1
. library

url="$(echo "$1" | sed -E 's|https://.*=(.*)\&?|https://youtu.be/\1|')"
link_id="$(echo "$1" | sed -E 's|https://.*=(.*)\&?|\1|')"
c=( "${@:2}" )
categories=$(echo "${c[@]}" | tr '[:upper:]' '[:lower:]' | tr ' ' '\t')
title="$(youtube-dl --get-title "$1" | sed -e 's/(/{/g; s/)/}/g' -e "s/'//g")"
if [ "${PIPESTATUS[0]}" -ne 0 ]
then
    unset title
fi
duration="$(youtube-dl --get-duration "$1" | sed -E 's/(.*):(.+):(.+)/\1*3600+\2*60+\3/;s/(.+):(.+)/\1*60+\2/' | bc)"
entry="$title	$url	$duration	$categories"


if ! output="$(./yt_add.sh "$link_id")"
then
    echo Failed to add to youtube playlist
    exit 1
fi

if [ -z "$title" ]
then
    title=$(echo "$output" | jq --raw-output '.snippet.title')
    if [ "$title" = "null" ]
    then
        echo Failed to get title from output
        exit 1
    fi
fi

echo adding "$entry"
if grep "$entry" "$PLAYLIST" >/dev/null
then
    echo "$entry" already in "$PLAYLIST" 2>&1
    exit 1
else
    echo "$entry" >> "$PLAYLIST"
    true
fi

