#!/bin/bash

[ -n "$SSH_CONNECTION" ] && [ -e /dev/stderr ] && exec >> /dev/stderr

if [ "$(uname -n)" = "mirrodin" ]
then
    export TERM=xterm-256color
fi
if [ "$TERM" = "linux" ]; then
    _SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    sed -n "$_SEDCMD" "$HOME"/.Xdefaults | awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}' | while read -r i
    do
        echo -en "$i"
    done
    clear
fi

if [[ -n $TMUX ]]; then
    exit() {
        tmux detach
    }
fi

start_tmux() {
    echo -n "Launch tmux session? [Y/n] "
    read -r r
    if [[ $r == "" ]] || [[ $r == "y" ]] || [[ $r == "Y" ]]; then
        if pgrep tmux &> /dev/null;
        then
            echo "\033[1mWhich session?\033[0m"
            tmux list-sessions \
                -F '#{session_name}:	(#{t:session_created})	#{?session_attached,yes,no}' \
                | column -s'	' -t -N 'name,session created at,atached'

            echo -n "(Nothing for a new session)> "
            read -r s
            if [ -z "$s" ]
            then
                tmux
            elif ! tmux attach -t "$s"
            then
                echo "Starting a new session"
                tmux
            fi
        else
            tmux
        fi
        exit
    fi
}

if [[ -z "$TMUX" ]] && [ -n "$SSH_CONNECTION" ] && hash tmux 2>/dev/null; then
    start_tmux
fi

if mn -V &> /dev/null && mn list | grep -v ' 0 ' > /dev/null
then
    mn list
else
    if [ -e /tmp ]
    then
        fortune -c
    else
        fortune
    fi
fi
if hash calcurse &>/dev/null
then
    calcurse --todo
fi
