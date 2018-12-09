#!/bin/bash

function newSpells {
    for f in "$(ls | grep '\.sh' | sed 's/\.sh//')"
    do
        if ! [ -h ~/.local/bin/"$f" ]
        then
            return 1
        fi
    done
    return 0;
}
mkdir -p ~/.local/bin

cd "$(dirname "$(realpath "$0")")" || return 0

newSpells || return 0
echo -e "\n\033[33mLearning Spells...\033[0m"

for spell in *.sh
do
    if ! [ -e ~/.local/bin/"$(basename "$spell" .sh)" ]
    then
        echo -e "\e[38;2;138;93;150m    $(basename "$spell" .sh)\e[0m"
        ln -s "$(pwd)/$spell" ~/.local/bin/"$(basename "$spell" .sh)"
    fi
done
echo -e "\033[33mDone!\033[0m"
