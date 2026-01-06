#!/bin/bash

exec &>/tmp/mendess/swhkd.log

swhks &
(
for i in {0..3000}; do
    if rfkill | grep -q ' blocked'; then
        rfkill unblock bluetooth wlan
        break
    fi

    sleep "$(bc <<<"$i / 1000")"
done
) &
disown

while sleep 1; do
    pkexec swhkd --cooldown 400 --config ~/.config/swhkd/swhkdrc
done
