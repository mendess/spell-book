#!/bin/bash

echo -en "\e[1;3$((RANDOM % 7 + 1))m"
command -V todo &>/dev/null &&
    todo --list --bg-pull
echo -en "\e[0m"
