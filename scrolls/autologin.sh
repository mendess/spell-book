#!/bin/bash
#shellcheck disable=2016
# Setup auto login with or without password

BLUE="\033[34m"
RESET="\033[0m"
case "$1" in
    username | full) ;;
    *)
        echo 'please pick either `full` or `username` only'
        exit 1
        ;;
esac
tty="${2:-tty1}"
user="${3:-$LOGNAME}"

sudo mkdir -p "/etc/systemd/system/getty@$tty.service.d/"
case "$1" in
    full)
        service='
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin '"$user"' --noclear %I $TERM
Type=simple'
        ;;
    username)
        service='
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --skip-login --login-options '"$user"' --noclear %I $TERM'
        ;;
esac

echo "$service" | sudo tee "/etc/systemd/system/getty@$tty.service.d/override.conf" >/dev/null

sudo systemctl enable "getty@$tty"

echo -e "Auto login for user $BLUE$user$RESET created on $BLUE$tty$RESET"
