#!/bin/bash
# Dynamic [i3|bspwm] workspace renamer
[ "$1" = GUI ] && picker=dmenu || picker=fzf
NEW=$(echo "" | PICKER="$picker" picker -p "Enter new ws name:" | sed 's/\t/    /g')

if pgrep i3; then
    WS=$(i3-msg -t 'get_workspaces' | jq '.[] |select(.focused == true).name' -r)
    WSNUM=$(echo "$WS" | cut -d':' -f1)
    i3-msg "rename workspace \"$WS\" to \"$WSNUM: $NEW\""

elif pgrep bspwm; then
    WSNUM=$(bspc query -D -d --names | grep -oP '^[0-9]+')
    if [[ "$NEW" ]]; then
        bspc desktop --rename "$WSNUM: $NEW"
    else
        bspc desktop --rename "$WSNUM"
    fi
elif pgrep herbstluftwm; then
    if [[ "$NEW" ]]; then
        herbstclient attr tags.focus.name \
            "$(($(herbstclient attr tags.focus.index) + 1)): $NEW"
    else
        herbstclient attr tags.focus.name \
            "$(($(herbstclient attr tags.focus.index) + 1))"
    fi
fi
