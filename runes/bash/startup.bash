#!/bin/bash

[ -n "$SSH_CONNECTION" ] && [ -e /dev/stderr ] && exec >>/dev/stderr && export TERM=xterm-256color

if [[ -n $TMUX ]]; then
    exit() {
        tmux detach
    }
fi

TMPDIR="${TMPDIR:-/tmp}"
[[ -e "$TMPDIR/todo" ]] && command cat "$TMPDIR/todo"
rsync mirrodin:todo "$TMPDIR" &>/dev/null &
disown
