export ZSH_THEME="fishy-2"
function exit {
    if [[ -z $TMUX ]]; then
        builtin exit
    else
        tmux detach
    fi
}

function start_tmux {
    if (pgrep tmux &> /dev/null); then
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

if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
    echo -n "Launch tmux session? [Y/n] "
    read -r r
    if [[ $r == "" ]] || [[ $r == "y" ]] || [[ $r == "Y" ]]; then
        start_tmux
        exit
    fi
fi

if mn -V > /dev/null
then
    mn list
else
    #fortune | cowthink `echo " \n-b\n-d\n-g\n-p\n-s\n-t\n-w\n-y" | shuf -n1`
    fortune -c
fi
