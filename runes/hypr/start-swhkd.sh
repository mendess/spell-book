#!/bin/bash

exec &>/tmp/mendess/swhkd.log

swhks &
swhkd --cooldown 400 --config ~/.config/swhkd/swhkdrc
