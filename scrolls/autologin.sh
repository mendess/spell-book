#!/bin/bash
#shellcheck disable=2016

case "$1" in
    username | full) ;;
    *)
        echo 'please pick either `full` or `username` only'
        exit 1
        ;;
esac

sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
case "$1" in
    full)
        service='
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin mendess --noclear %I $TERM
Type=simple'
        ;;
    username)
        service='
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --skip-login --login-options mendess --noclear %I $TERM'
        ;;
esac

echo "$service" | sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf

sudo systemctl enable getty@tty1
