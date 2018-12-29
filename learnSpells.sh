#!/bin/bash

function newSpells {
    for spell in spells/*.spell
    do
        [ -h ~/.local/bin/"$(basename "$spell" .spell)" ] || return 0
    done
    return 1;
}
mkdir -p ~/.local/bin
cd "$(dirname "$(realpath "$0")")" || return 0

newSpells || exit 0

echo -e "\033[33mLearning Spells...\033[0m"

for spell in spells/*.spell
do
    if ! [ -e ~/.local/bin/"$(basename "$spell" .spell)" ]
    then
        echo -e "\e[38;2;138;93;150m    $(basename "$spell" .spell)\e[0m"
        ln -s "$(pwd)/$spell" ~/.local/bin/"$(basename "$spell" .spell)"
    fi
done
echo -e "\033[33mDone!\033[0m"
