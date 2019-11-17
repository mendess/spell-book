#!/bin/bash

exec >> /dev/stderr

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
    if pgrep tmux &> /dev/null;
    then
        echo "\033[1mRunning sessions:\033[0m"
        tmux list-sessions \
            -F '#{session_name}:	(#{t:session_created})	#{?session_attached,yes,no}' \
            | column -s'	' -t -N 'name,session created at,atached'
        echo -n "Resume old session? [Y/n] "
        read -r r
        if [[ $r == "" ]] || [[ $r == "y" ]] || [[ $r == "Y" ]]; then
            local sessions
            sessions=$(tmux list-sessions | cut -d":" -f1)
            if [[ $(echo "$sessions" | wc -l) != "1" ]]; then
                echo "Which session?"
                echo "$sessions"
                echo -n "(default=$(echo "$sessions" | head -1))> "
                read -r s
                [[ -z "$s" ]] && s=$(echo "$sessions" | head -1)
                tmux attach -t "$s"
            else
                tmux attach
            fi
        else
            tmux
        fi
    else
        tmux
    fi
}

if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ] && hash ls 2>/dev/null; then
    echo -n "Launch tmux session? [Y/n] "
    read -r r
    if [[ $r == "" ]] || [[ $r == "y" ]] || [[ $r == "Y" ]]; then
        start_tmux
        exit
    fi
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
