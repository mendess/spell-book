#!/bin/bash

if ! [ -e ~/.links/mcserverip ]
then
    notify-send "Error:" "$HOME/.links/mcserverip No such file"
    exit
fi

if ! hash mcstatus
then
    notify-send "Error:" "mcstatus not installed. Please run 'pip install --user mcstatus'"
    exit 1
fi

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
