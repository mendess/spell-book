#!/bin/bash

for dir in $(find . -mindepth 1 -maxdepth 1 -type d)
do
    cd "$dir" || continue
    if ! git diff-index --quiet HEAD --
    then
        echo -e "\033[32m$(pwd)\033[0m"
        git status
    fi
    cd ..
done
