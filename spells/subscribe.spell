#!/bin/bash

help() {
    cat <<EOF
Usage: $0 [-u|-i] param
    -u --url url
        Specify a channel url from which to get the id
    -i --id id
        Specify the id directly
EOF
exit 42
}

tags=()
while [ "$#" -gt 0 ]; do
    case "$1" in
        -u|--url)
            id="$(curl "$2" | grep channelId | head -1 | cut -d'"' -f4)"
            shift
            ;;
        -i|--id)
            id="$2"
            shift
            ;;
        *)
            tags+=("$1")
    esac
    shift
done
[ -n "$id" ] || help

if grep "$id" ~/.config/newsboat/urls >/dev/null ; then
    echo 'Id already subscribed'
    exit 1
fi

feed="https://www.youtube.com/feeds/videos.xml?channel_id=$id yt ${tags[*]}"

printf "Adding this feed:\n\t%s\n" "$feed"

echo "$feed" >> ~/.config/newsboat/urls
