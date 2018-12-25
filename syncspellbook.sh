#!/bin/bash

function sync {
    localRemote="$(git rev-parse @{u})"
    echo -en "\033[32m"; git add --verbose --all; echo -en "\033[0m"

    if ! git diff-index --quiet HEAD --; then
        hasCommits="true"
        git commit -m"Backup spell book | $(date '+%d/%m/%y %H:%M')"
    else
        echo -e "\033[34mNothing to backup\033[0m"
    fi

    echo -en "\033[32m"
    echo -n "Checking remote..."
    echo -en "\033[34m"
    git fetch &>/dev/null
    fetch="$?"
    echo -en "\033[0m"
    echo -en "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
    if ! [ "$fetch" = "0" ]; then
        echo -e "\033[31mCan't access github\033[0m"
        return 2
    fi

    if [ "$localRemote" != "$(git rev-parse @{u})" ]; then
        hasPulls="true"
    else
        echo -e "\033[34mNothing to pull\033[0m"
    fi

    if [ -n "$hasCommits" ] && [ -n "$hasPulls" ]; then
        while true
        do
            git pull --rebase
            git status | grep "rebase in progress" > /dev/null || break
            echo -e "\033[31mConflicts emerged, please resolve them\033[0m"
            read -r
            rebase=1
            for file in $(git status --short | grep UU | cut -d" " -f2)
            do
                nvim "$file" || vim "$file"
            done
            git add -A
            git rebase --continue
        done

        if [[ $rebase != 0 ]]; then
            git push --quiet
        fi
    elif [ -n "$hasCommits" ]; then
        git push --quiet
    elif [ -n "$hasPulls" ]; then
        git pull --rebase
    fi

    bash ./learnSpells.sh
    bash ./castRunes.sh
    return 0
}
farrow="=======> "
barrow=" <======="
cd "$(dirname "$(realpath "$0")")" || exit 1
echo -e     "\033[33m${farrow}  Back me up inside!  ${barrow}\033[0m"
sync
if [ $? ]
then
    echo -e "\033[33m${farrow}Back me up and save me${barrow}\033[0m"
else
    echo -e "\033[31m${farrow}     Can't backup     ${barrow}\033[0m"
fi
read -n 1 -s -r
