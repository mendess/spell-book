#!/bin/bash
if git diff-index --quiet HEAD --
then
    echo -e "\033[34mNothing to backup\033[0m"
    exit 1
fi

