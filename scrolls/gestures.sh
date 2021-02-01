#!/bin/sh
# Enable gestures to switch workspace

if ! hash aura 2>/dev/null
then
    echo Requires aura
    exit 1
fi

aura -S libinput-gestures
sudo gpasswd -a "$USER" input
libinput-gestures-setup autostart

echo 'Reboot to apply changes? [y/N] '
read -r response
if [ "$response" = "y" ] || [ "$response" = "Y" ]
then
    reboot
fi
