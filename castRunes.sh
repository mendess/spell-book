#!/bin/bash

runes=(
~/.zprofile
~/.oh-my-zsh/custom/themes/fishy-2.zsh-theme
~/.oh-my-zsh/custom/startup.zsh
~/.oh-my-zsh/custom/aliases.zsh
~/.gitignore-global
~/.config/zathura/zathurarc
~/.config/nvim/init.vim
~/.config/i3status
~/.config/i3
~/.config/dunst/dunstrc
~/.Xdefaults
~/.IntelliJIdea2018.3/config/idea.properties
~/.config/mutt/muttrc
~/.config/mutt/colors.muttrc
)

function cleanRunes {
    for rune in "${runes[@]}"
    do
        if [ -h "$rune" ] && ! [ -e "$rune" ]; then
            echo -e "\033[31mRemoving broken rune: $(basename $rune)\033[0m"
            rm $rune
        fi
    done
    return 1;
}

function newRunes {
    for rune in "${runes[@]}"
    do
        [ -h "$rune" ] || return 0
    done
    return 1
}

cleanRunes
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
        echo -en "\033[35mCasting "
        ln -sfv "$(pwd)/$(basename "$rune")" "$rune"
        echo -en "\033[0m"
    fi
done
echo -e "\033[33mDone!\033[0m"
