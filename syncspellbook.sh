#!/bin/bash

function sync {
    echo -en "\033[32m"
    git add --verbose --all
    echo -en "\033[0m"

    if ! git diff-index --quiet HEAD --
    then
        git commit -m"Backup spell book | $(date '+%d/%m/%y %H:%M')"
    fi

    echo -en "\033[32m"
    echo -n "Checking remote..."
    git fetch --quiet
    fetch=$?
    echo -en "\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
    echo -en "\033[0m"
    if ! [ $fetch ]
    then
        echo -e "\033[31mCan't access github\033[0m"
        return 2
    fi

    if [ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]
    then
        git pull --rebase

        while [[ $? != 0 ]]
        do
            echo -e "\033[31mConflicts emerged, please resolve them\033[0m"
            read
            rebase=1
            for file in $(git status --short | grep UU | cut -d" " -f2)
            do
                nvim $file || vim $file
            done
            git add -A
            git rebase --continue
        done

        if [[ $rebase != 0 ]]
        then
            git push --quiet
        fi
    fi

    bash ./learnSpells.sh
    bash ./castRunes.sh
}

cd $(dirname "$(realpath $0)")
echo -e "\033[34mBack me up inside\033[0m"
sync
if [ $? ]
then
    echo -e "\033[32mBack me up and save me"
else
    echo -e "\033[31mCan't backup\033[0m"
fi
