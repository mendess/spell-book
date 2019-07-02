#!/bin/sh

MEMBERS=$(mcstatus "$(cat ~/.links/mcserverip)" status \
    | grep players \
    | cut -d' ' -f3- \
    | sed -E -e 's/.*\[(.*)\]/\1/g' -e 's/, /\n/g' -e "s/'//g" \
    | awk '$0 !~ /No players online/ {print $1}')

if [ -z "$MEMBERS" ]
then
    notify-send "No one online"
else
    notify-send "Members online" "$MEMBERS"
fi
