#!/bin/bash
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <link>"
    exit 1
fi

cd "$(dirname "$(realpath "$0")")" || exit 1
eval "$(library)"

url="$(echo "$1" | sed -E 's|https://.*=(.*)\&?|https://youtu.be/\1|')"

c=( "${@:2}" )
categories=$(echo "${c[@]}" | tr ' ' '\t')

if ! link="$(youtube-dl --get-title "$1" | sed -e 's/(/{/g; s/)/}/g' -e "s/'//g")	$url	$categories"
then
    echo yt dl failed
    exit
fi

echo adding "$link"
if grep "$link" "$PLAYLIST" >/dev/null
then
    echo "$link" already in "$PLAYLIST" 2>&1
    exit 1
else
    echo "$link" >> "$PLAYLIST"
    true
fi

link_id="$(echo "$link" | awk -F'\t' '{print $2}' | sed -E 's|.*be/(.*)|\1|g')"
./yt_add.sh "$link_id"
