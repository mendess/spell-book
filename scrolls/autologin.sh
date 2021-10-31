#!/bin/bash
#shellcheck disable=2016
# Setup auto login with or without password

BLUE="\033[34m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"
tty="${2:-tty1}"
user="${3:-$LOGNAME}"

if ! [[ $tty =~ tty[0-9] ]]; then
    echo "invalid tty name '$tty'"
    exit 1
fi

service_name="getty@$tty"
service_dir="/etc/systemd/system/$service_name.service.d"

enable() {
    sudo mkdir -pv "$service_dir"

    echo "$service" | sudo tee "$service_dir/override.conf" >/dev/null

    sudo systemctl enable "$service_name"

    echo -e "Auto login for user $BLUE$user$RESET ${GREEN}created$RESET on $BLUE$tty$RESET"
}

case "$1" in
    reset)
        if sudo rm -rv "$service_dir" ; then
            echo -e "Auto login on $BLUE$tty$RESET has been ${RED}disabled$RESET"
        else
            echo -e "Auto login was already ${RED}disabled$RESET on $tty"
        fi
        exit
        ;;

    full)
        service='
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin '"$user"' --noclear %I $TERM
Type=simple'
        enable
        ;;
    username)
        service='
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --skip-login --login-options '"$user"' --noclear %I $TERM'
        enable
        ;;

    *)
        echo 'please pick either `full`, `username` or reset'
        exit 1
        ;;
esac

