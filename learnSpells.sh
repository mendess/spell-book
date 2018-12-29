#!/bin/bash

function cleanSpells {
    for spell in ~/.local/bin/*
    do
        if [ -h "$spell" ] && ! [ -e "$spell" ]; then
            echo -e "\033[31mRemoving dead spell: $(basename $spell)\033[0m"
            rm $spell
        fi
    done
    return 1;
}

function newSpells {
    for spell in spells/*.spell; do
        [ -h ~/.local/bin/"$(basename "$spell" .spell)" ] || return 0
    done
    return 1;
}

mkdir -p ~/.local/bin
cd "$(dirname "$(realpath "$0")")" || return 0

cleanSpells
newSpells || exit 0

echo -e "\033[33mLearning Spells...\033[0m"

for spell in spells/*.spell
do
    spell_name=$(basename "$spell" .spell)
    if ! [ -e ~/.local/bin/"$spell_name" ]; then
        echo -e "\033[35m\t$spell_name\033[0m"
        ln -s "$(pwd)/$spell" ~/.local/bin/"$spell_name"
    fi
done
chmod +x spells/*
echo -e "\033[33mDone!\033[0m"
