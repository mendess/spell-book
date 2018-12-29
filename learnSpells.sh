#!/bin/bash

function newSpells {
    for spell in spells/*.sh
    do
        [ -h ~/.local/bin/"$(basename "$spell" .sh)" ] || return 0
    done
    return 1;
}
mkdir -p ~/.local/bin
cd "$(dirname "$(realpath "$0")")" || return 0

newSpells || exit 0

echo -e "\033[33mLearning Spells...\033[0m"

for spell in spells/*.sh
do
    if ! [ -e ~/.local/bin/"$(basename "$spell" .sh)" ]
    then
        echo -e "\e[38;2;138;93;150m    $(basename "$spell" .sh)\e[0m"
        ln -fs "$(pwd)/$spell" ~/.local/bin/"$(basename "$spell" .sh)"
    fi
done
echo -e "\033[33mDone!\033[0m"
