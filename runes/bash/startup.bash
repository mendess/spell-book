#!/bin/bash

TMPDIR="${TMPDIR:-/tmp}"
[[ -e "$TMPDIR/todo" ]] &&
    echo -e "\e[1;31m" &&
    command cat "$TMPDIR/todo" &&
    echo -e "\e[0m"
rsync mirrodin:todo "$TMPDIR" &>/dev/null &
disown
