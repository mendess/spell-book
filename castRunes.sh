#!/bin/bash

runes=( ~/.oh-my-zsh/custom/aliases.zsh ~/.config/nvim/init.vim ~/.oh-my-zsh/custom/startup.zsh )

cd $(dirname "$(realpath $0)")"/runes"

for rune in "${runes[@]}";
do
    if [[ $spell != $(basename $0) && ! -e ~/.local/bin/$(basename $spell .sh) ]]
    then
        echo -e "\e[38;2;138;93;150mCasting "$(basename $rune)"\e[0m"
        ln -fsv $(pwd)"/"$(basename $rune) $rune
    fi
done
