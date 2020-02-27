#!/bin/bash

[ -n "$SSH_CONNECTION" ] && [ -e /dev/stderr ] && exec >> /dev/stderr && export TERM=xterm-256color

start_tmux() {
    echo -n "Launch tmux session? [Y/n] "
    read -r r
    if [[ $r == "" ]] || [[ $r == "y" ]] || [[ $r == "Y" ]]; then
        if pgrep tmux &> /dev/null;
        then
            echo -e "\033[1mWhich session?\033[0m"
            tmux list-sessions \
                -F '#{session_name}:	(#{t:session_created})	#{?session_attached,yes,no}' \
                | column -s'	' -t -N 'name,session created at,atached'

            echo -n "(Nothing for a new session)> "
            read -r s
            if [ -z "$s" ]
            then
                tmux -2
            elif ! tmux attach -t "$s"
            then
                echo "Starting a new session"
                tmux -2
            fi
        else
            tmux -2
        fi
        exit
    fi
}

if [[ -z "$TMUX" ]] && [ -n "$SSH_CONNECTION" ] && hash tmux 2>/dev/null; then
    start_tmux
fi

if [[ -n $TMUX ]]; then
    exit() {
        tmux detach
    }
fi

if mn -V &> /dev/null && mn list | grep -v ' 0 ' > /dev/null
then
    mn list
else
    if hash fortune ; then
        if [ -e /tmp ]
        then
            fortune -c
        else
            fortune
        fi
    fi
fi
if hash calcurse &>/dev/null
then
    calcurse --todo
fi
