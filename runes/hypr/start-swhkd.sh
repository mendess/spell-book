#!/bin/bash

exec &>/tmp/mendess/swhkd.log

swhks &
pkexec swhkd -c ~/.config/swhkd/swhkdrc
