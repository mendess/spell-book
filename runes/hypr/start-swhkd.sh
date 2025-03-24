#!/bin/bash

exec &>/tmp/mendess/swhkd.log

swhks &
pkexec swhkd --cooldown 400 --config ~/.config/swhkd/swhkdrc &
for i in {0..5000}; do
    if rfkill | grep -q ' blocked'; then
        rfkill unblock bluetooth wlan
        break
    fi

    sleep "$(bc <<<"$i / 1000")"
done
disown
