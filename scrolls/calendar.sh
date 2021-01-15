sudo pacman -Sy vdirsyncer --needed --noconfirm

vdirsyncer discover calendar
vdirsyncer sync calendar
vdirsyncer metasync --max-workers=1

(crontab -l ; echo "0 * * * * vdirsyncer sync calendar") | awk '!a[$0]++' | crontab -
