#!/bin/bash
# trayer launcher

export hc=herbstclient

primary=$(
    mon=$(xrandr --listactivemonitors |
        sed -E 's|/[0-9]+||g' |
        awk '/.*\*.*/ {print $1 $3}')
    $hc list_monitors | grep -F "$(cut -d: -f2 <<<"$mon")" | cut -d: -f1
)


pad=$($hc attr monitors.$primary.pad_up)

if pgrep -x trayer >/dev/null; then
    killall -q trayer nm-applet
    $hc attr monitors.$primary.pad_up "$(( pad - 22 ))"
else
    $hc attr monitors.$primary.pad_up "$(( pad + 22 ))"

    trayer \
        --edge top \
        --distance $pad \
        --align right \
        --height 22 \
        --transparent true \
        --alpha 77 \
        --monitor primary \
        --tint 0x222222 &

    nm-applet &
fi

