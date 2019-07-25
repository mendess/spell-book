#!/bin/sh

eval "$(library)"

cd "$(dirname "$(realpath "$0")")" || exit 1

num_results="$(grep -c -i "$*" "$PLAYLIST")"
if [ "$num_results" -gt "1" ]
then
    echo too many results
    grep -i "$*" "$PLAYLIST" | awk -F'\t' '{print $1}'
    exit 1
fi
if [ "$num_results" -lt "1" ]
then
    echo no results
    exit 1
fi
if ./yt_delete.sh "$@"
then
    sed -i '/'"$*"'/Id' "$PLAYLIST"
fi
