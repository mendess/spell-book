#!/bin/bash

runes=( ~/.oh-my-zsh/custom/aliases.zsh ~/.config/nvim/init.vim ~/.oh-my-zsh/custom/startup.zsh )

for rune in "${runes[@]}";
do
    echo -e "\e[38;2;138;93;150mCasting "$(basename $rune)"\e[0m"
    ln -fs $(pwd)"/"$(basename $rune) $rune
done
