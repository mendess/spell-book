#!/bin/bash
# Dynamic [i3|bspwm|herbstluftwm] workspace renamer
set -o pipefail
set -e

if [ "$1" = GUI ]; then
    NEW=$(picker -p "Enter new ws name:" </dev/null)
else
    NEW=$(fzf --print-query --prompt "Enter new ws name: " </dev/null | head -1) || true
fi

NEW=$(printf "%s" "$NEW" | sed 's/\t/    /g') || exit

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
            "$((($(herbstclient attr tags.focus.index) + 1) % 10)): $NEW"
    else
        herbstclient attr tags.focus.name \
            "$((($(herbstclient attr tags.focus.index) + 1) % 10))"
    fi
fi
