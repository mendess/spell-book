#!/bin/bash

echo -e "\e[1;31m"
command -V todo >/dev/null &&
    todo --list --bg-pull
echo -e "\e[0m"
