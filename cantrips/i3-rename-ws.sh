#!/bin/bash
# Dynamic i3 workspace renamer

WS=$(i3-msg -t 'get_workspaces' | jq '.[] |select(.focused == true).name' -r)
WSNUM=$(echo "$WS" | cut -d':' -f1)
NEW=$(echo "" | dmenu -p "Enter new ws name:")
i3-msg "rename workspace \"$WS\" to \"$WSNUM: $NEW\""
