#!/bin/bash

echo -e "\n\033[33m Casting Runes...\033[0m"

runes=( ~/.oh-my-zsh/custom/aliases.zsh ~/.config/nvim/init.vim ~/.oh-my-zsh/custom/startup.zsh ~/.gitignore ~/.config/i3 ~/.config/i3status ~/.Xdefaults ~/.oh-my-zsh/themes/fishy-2.zsh-theme ~/.zprofile )

cd $(dirname "$(realpath $0)")"/runes"

for rune in "${runes[@]}";
do
    if ! [ -e $(dirname $rune) ] # if the directory doesn't exist, create it
    then
        echo -e "\033[31mMissing \033[36m$(dirname $rune)\033[31m directory, creating....\033[0m"
        mkdir --verbose --parent $(dirname $rune)
    fi
    if ! [ -h $rune ]
    then
        echo -en "\e[38;2;138;93;150mCasting "
        ln -sfv $(pwd)"/"$(basename $rune) $rune
        echo -en "\e[0m"
    fi
done
echo -e "\033[33m Done!\033[0m"
