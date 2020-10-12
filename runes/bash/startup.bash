#!/bin/bash

[ -n "$SSH_CONNECTION" ] && [ -e /dev/stderr ] && exec >>/dev/stderr && export TERM=xterm-256color

if [[ -n $TMUX ]]; then
    exit() {
        tmux detach
    }
fi

[[ -z "$TMUX" ]] && [[ "$SSH_CONNECTION" ]] && command -v tmux &>/dev/null &&
    tmux -2 new -A -s default &&
    exit

TMPDIR="${TMPDIR:-/tmp}"
[[ -e "$TMPDIR/todo" ]] && cat "$TMPDIR/todo"
rsync mirrodin:todo "$TMPDIR" &>/dev/null &
disown
