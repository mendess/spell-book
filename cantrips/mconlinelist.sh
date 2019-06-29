#!/bin/sh

MEMBERS=$(mcstatus "$(cat ~/.links/mcserverip)" status | tail -1 | sed -E -e 's/.*\[(.*)\]/\1/g' -e 's/, /\n/g' -e "s/'//g" | awk '{print $1}')
if [ -z "$MEMBERS" ]
then
    notify-send "No one online"
else
    notify-send "Members online" "$MEMBERS"
fi
