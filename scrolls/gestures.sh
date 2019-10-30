#!/bin/sh

if ! hash yay 2>/dev/null
then
    echo Requires yay
    exit 1
fi

echo '1
n' | yay -S libinput-gestures
sudo gpasswd -a "$USER" input
libinput-gestures-setup autostart

echo 'Reboot to apply changes? [y/N] '
read -r response
if [ "$response" = "y" ] || [ "$response" = "Y" ]
then
    reboot
fi
