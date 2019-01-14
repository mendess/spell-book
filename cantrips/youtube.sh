#!/bin/sh

vidlist=$(sed '/^$/ d' links)

vidname="$(echo "$vidlist" | cut -d';' -f1 | dmenu -i -p "Which video? (type: \"shuff\" to pick at random)" -l $(echo "$vidlist" | wc -l))"

if [ "$vidname" = "shuff" ]; then
    vid=$(echo "$vidlist" | shuf | sed '1q' | cut -d';' -f2)
    title=$(echo "$vidlist" | grep "$vid" | cut -d';' -f1)
elif [ "$vidname" = "shuffA" ]; then
    tmp=$(echo "$vidlist" | shuf)
    vid=$(echo "$tmp" | cut -d';' -f2 | xargs)
    title="$(echo "$tmp" | cut -d';' -f1)"
else
    vid="$(echo "$vidlist" | grep -P "^$vidname;" | cut -d';' -f2)"
    title="$vidname"
fi
[ "$vid" = "" ] && exit

p=$(echo "no\nyes" | dmenu -i -p "With video?")

if [ "$p" = "yes" ]
then
    mpv $vid
elif [ "$p" = "no" ]
then
    cmd="echo -e '\n$title'; mpv --input-ipc-server=/tmp/mpvsocket --no-video $vid"
    urxvt -fn "xft:DejaVu Sans Mono:autohint=true:size=20" -title 'my-media-player' -e bash -c "$cmd"
fi

