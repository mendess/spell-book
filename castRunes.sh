#!/bin/bash

runes=(
~/.oh-my-zsh/custom/aliases.zsh
~/.oh-my-zsh/custom/themes/fishy-2.zsh-theme
~/.oh-my-zsh/custom/startup.zsh
~/.zprofile
~/.Xdefaults
~/.gitignore
~/.config/nvim/init.vim
~/.config/zathura/zathurarc
~/.config/mpv/mpv.conf
~/.config/i3
~/.config/i3status
)

function newRunes {
    for rune in "${runes[@]}"
    do
        if ! [ -h "$rune" ]
        then
            return 0
        fi
    done
    return 1
}


newRunes || exit 0

echo -e "\033[33mCasting Runes...\033[0m"

cd "$(dirname "$(realpath "$0")")""/runes" || exit 1

for rune in "${runes[@]}";
do
    # if there was a rune group specified and this doesn't fit, skip it
    [[ $1 != "" ]] && [[ $rune != *"$1"* ]] && continue

    if ! [ -e "$(dirname "$rune")" ] # if the directory doesn't exist, create it
    then
        echo -e "\033[31mMissing \033[36m$(dirname "$rune")\033[31m directory, creating....\033[0m"
        mkdir --verbose --parent "$(dirname "$rune")"
    fi
    if ! [ -h "$rune" ]
    then
        echo -en "\e[38;2;138;93;150mCasting "
        ln -sfv "$(pwd)/$(basename "$rune")" "$rune"
        echo -en "\e[0m"
    fi
done
echo -e "\033[33mDone!\033[0m"
