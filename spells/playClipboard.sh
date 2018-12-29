#!/bin/bash

if mpv "$(xclip -sel clip -o)" &
then
    disown
    exit
fi
