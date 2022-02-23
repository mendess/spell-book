#!/bin/bash

printf "\e[1;3$((RANDOM % 7 + 1))m"
command -V todo &>/dev/null &&
    [[ -z "$ASCIINEMA_REC" ]] &&
    todo --list --bg-pull
printf "\e[0m"
