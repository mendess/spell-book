#!/bin/bash

echo -en "\e[1;31m"
command -V todo &>/dev/null &&
    todo --list --bg-pull
echo -en "\e[0m"

command -V nmcli &>/dev/null && {
    nmcli -t --fields NAME connection show --active | grep -q 'ZON.*2010' &&
        { cat /tmp/memo 2>/dev/null || :; }
    (
        scp -q mirrodin:memo /tmp/memo &

    )
}
