#!/bin/bash

[ -n "$SSH_CONNECTION" ] && [ -e /dev/stderr ] && exec >>/dev/stderr && export TERM=xterm-256color

if [[ -n $TMUX ]]; then
    exit() {
        tmux detach
    }
fi

TMPDIR="${TMPDIR:-/tmp}"
[[ -e "$TMPDIR/todo" ]] &&
    echo -e "\e[1;31m" &&
    command cat "$TMPDIR/todo" &&
    echo -e "\e[0m"
rsync mirrodin:todo "$TMPDIR" &>/dev/null &
disown
