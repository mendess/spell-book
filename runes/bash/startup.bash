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

if mn -V &>/dev/null && mn list | grep -v ' 0 ' >/dev/null; then
    mn list
else
    if command -v fortune &>/dev/null; then
        if [[ -e /tmp ]]; then
            fortune -c
        else
            fortune
        fi
    fi
fi
if command -v calcurse &>/dev/null; then
    calcurse --todo
fi
