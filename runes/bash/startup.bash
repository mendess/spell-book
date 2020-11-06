#!/bin/bash

echo -en "\e[1;31m"
command -V todo &>/dev/null &&
    todo --list --bg-pull
echo -en "\e[0m"
