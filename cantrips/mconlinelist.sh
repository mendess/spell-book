#!/bin/bash

if ! [ -e "$LINKS"/mcserverip ]
then
    notify-send "Error:" "$LINKS/mcserverip No such file" -a "$(basename "$0")"
    exit
fi

if ! hash mcstatus
then
    notify-send "Error:" "mcstatus not installed. Please run 'pip install --user mcstatus'" -a "$(basename "$0")"
    exit 1
fi

MEMBERS=$(mcstatus "$(cat "$LINKS"/mcserverip)" status \
    | grep players \
    | cut -d' ' -f3- \
    | sed -E -e 's/.*\[(.*)\]/\1/g' -e 's/, /\n/g' -e "s/'//g" \
    | awk '$0 !~ /No players online/ {print $1}')

if [ -z "$MEMBERS" ]
then
    notify-send "No one online" -a "$(basename "$0")"
else
    notify-send "Members online" "$MEMBERS" -a "$(basename "$0")"
fi
