#!/bin/bash

echo -en "\e[1;31m"
command -V todo &>/dev/null &&
    todo --list --bg-pull
echo -en "\e[0m"

{
    cat /tmp/memo
    {
        nmcli -t --fields NAME connection show --active | grep -q 'ZON.*2010' &&
            scp -q mirrodin:memo /tmp/memo
    } &
    disown
} 2>/dev/null
