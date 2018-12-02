fortune | cowthink $(echo " \n-b\n-d\n-g\n-p\n-s\n-t\n-w\n-y" | shuf -n1)

ZSH_THEME="fishy-2"
function exit {
    if [[ -z $TMUX ]]; then
        builtin exit
    else
        tmux detach
    fi
}

function __start_tmux {
    unset __start_tmux
    if (pgrep tmux &> /dev/null); then
        echo -n "Resume old session? [Y/n] "
        read r
        if [[ $r == "" ]] || [[ $r == "y" ]] || [[ $r == "Y" ]]; then
            local sessions=$(tmux list-sessions | cut -d":" -f1)
            if [[ $(echo "$sessions" | wc -l) != "1" ]]; then
                echo "Which session?"
                echo "$sessions"
                echo -n "(default=$(echo "$sessions" | head -1))> "
                read r
                tmux attach -s $r
            fi
        fi
        tmux attach
    else
        tmux
    fi
    exit
}

if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
    echo -n "Launch tmux session? [Y/n] "
    read r
    if [[ $r == "" ]] || [[ $r == "y" ]] || [[ $r == "Y" ]]; then
        __start_tmux
    fi
fi
