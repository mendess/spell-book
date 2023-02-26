#!/bin/sh
# Configure khal using vdirsyncer


sudo pacman -Sy vdirsyncer --needed --noconfirm

vdirsyncer discover calendar
vdirsyncer sync calendar
vdirsyncer metasync

(crontab -l ; echo "0 * * * * vdirsyncer sync calendar") | awk '!a[$0]++' | crontab -
