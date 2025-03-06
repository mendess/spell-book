#!/bin/bash

exec &>/tmp/mendess/swhkd.log

swhks &
pkexec swhkd --cooldown 400 --config ~/.config/swhkd/swhkdrc
