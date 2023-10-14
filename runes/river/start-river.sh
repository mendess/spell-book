#!/bin/bash

export MOZ_ENABLE_WAYLAND=1
export XKB_DEFAULT_OPTIONS=caps:escape

# TODO: change this to exec
river -c "$HOME/.config/river/init first-boot"

read -r -p "RIVER EXITED. Press enter to launch X" &>/dev/tty
