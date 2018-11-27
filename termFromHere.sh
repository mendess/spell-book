#!/bin/bash
# depends: xorg-xdpyinfo xorg-xprop
ID=$(xdpyinfo | grep focus | cut -f4 -d " ")
PID=$(xprop -id $ID | grep -m 1 PID | cut -d " " -f 3)
if [ -e "/proc/$PID/cwd" ]
then
    urxvt -cd $(readlink /proc/$PID/cwd) &
else
    urxvt
fi
