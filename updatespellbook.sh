#!/bin/bash

git pull --rebase

while [[ $? != 0 ]]
do
    rebase=1
    for file in $(git status --short | grep UU | cut -d" " -f2)
    do
        vim $file
    done
    git add -A
    git rebase --continue
done

if [[ $rebase != 0 ]]
then
    git push
fi
