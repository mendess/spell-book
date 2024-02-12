#!/bin/bash

export XKB_DEFAULT_OPTIONS=caps:escape
export MOZ_ENABLE_WAYLAND=1
export LIBVA_DRIVER_NAME=nvidia
export XDG_SESSION_TYPE=wayland
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export WLR_NO_HARDWARE_CURSORS=1

# TODO: change this to exec
river -c "$HOME/.config/river/init first-boot"
