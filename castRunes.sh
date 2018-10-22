#!/bin/bash

echo -e "\n\033[33m Casting Runes...\033[0m\n"

runes=( ~/.oh-my-zsh/custom/aliases.zsh ~/.config/nvim/init.vim ~/.oh-my-zsh/custom/startup.zsh ~/.gitignore )

cd $(dirname "$(realpath $0)")"/runes"

for rune in "${runes[@]}";
do
    if ! [ -e $(dirname $rune) ]
    then
        echo -e "\033[31mMissing \033[36m$(dirname $rune)\033[31m directory, \033[36m$(basename $rune)\033[31m was not cast.\033[0m"
    elif ! [ -h $rune ]
    then
        echo -en "\e[38;2;138;93;150mCasting "
        ln -sv $(pwd)"/"$(basename $rune) $rune
        echo -en "\e[0m"
    else
        echo -e "\033[36m"$rune"\033[32m already cast, skipping...\033[0m"
    fi
done
