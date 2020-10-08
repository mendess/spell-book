#!/bin/bash

[ -n "$SSH_CONNECTION" ] && [ -e /dev/stderr ] && exec >>/dev/stderr && export TERM=xterm-256color

if [[ "$(hostname)" =~ tolaria|mirrodin|weatherlight|matess ]] &&
    [[ -z "$TMUX" ]] && [ -n "$SSH_CONNECTION" ] && command -v tmux &>/dev/null; then
    tmux -2 new -A -s default
    exit
fi

if [[ -n $TMUX ]]; then
    exit() {
        tmux detach
    }
fi

if [[ -e /tmp/todo ]]; then
    cat /tmp/todo
fi
rsync mirrodin:todo /tmp/ & disown
