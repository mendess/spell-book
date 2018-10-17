#!/bin/bash

runes=( ~/.oh-my-zsh/custom/aliases.zsh ~/.config/nvim/init.vim ~/.oh-my-zsh/custom/startup.zsh )

cd $(dirname "$(realpath $0)")"/runes"

for rune in "${runes[@]}";
do
    if [ -h $rune ]
    then
        echo -e "\e[38;2;138;93;150mCasting "$(basename $rune)"\e[0m"
        ln -sv $(pwd)"/"$(basename $rune) $rune
    fi
done
