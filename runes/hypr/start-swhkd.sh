#!/bin/bash

exec &>/tmp/mendess/swhkd.log

swhks &
pkexec swhkd --cooldown 400 --config ~/.config/swhkd/swhkdrc &
while :; do
    if rfkill | grep -q ' blocked'; then
        rfkill unblock bluetooth wlan
        break
    fi
done
wait
