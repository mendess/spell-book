#!/bin/bash

cd "$(dirname "$(realpath "$0")")""/runes" || exit 1

runes=(
~/.zprofile,zprofile
~/.oh-my-zsh/custom/themes/fishy-2.zsh-theme,fishy-2.zsh-theme # Come back for this
~/.oh-my-zsh/custom,zsh
~/.gitignore-global,gitignore-global
~/.config/zathura/zathurarc,zathurarc
~/.config/nvim,nvim
~/.config/mutt,mutt
~/.config/i3status/config,i3status
~/.config/i3/config,i3
~/.config/dunst/dunstrc,dunstrc
~/.Xdefaults,Xdefaults
~/.IntelliJIdea2018.3/config/idea.properties,idea.properties
)

function cleanRunes {
    local rune link file
    for rune in "${runes[@]}"
    do
        IFS=',' read -r link file <<< "${rune}"
        if [ -d "$file" ]
        then
            for f in "$file"/*
            do
                l="$link/$(basename "$f")"
                if [ -h "$l" ] && ! [ -e "$l" ]
                then
                    echo -e "\033[31mRemoving broken rune: $(basename "$l")\033[0m"
                    rm "$l"
                fi
            done
        fi
        if [ -h "$link" ] && ! [ -e "$link" ]
        then
            echo -e "\033[31mRemoving broken rune: $(basename "$link")\033[0m"
            rm "$link"
        fi
    done
    return 1;
}

function newRunes {
    local rune link file
    for rune in "${runes[@]}"
    do
        IFS=',' read -r link file <<< "${rune}"
        [ -h "$link" ] || [ -d "$link" ] || return 0 # TODO: Come back to this
    done
    return 1
}

function linkRune {
    if ! [ -h "$2" ]
    then
        echo -en "\033[35mCasting "
        ln --symbolic --verbose "$(pwd)/$1" "$2"
        echo -en "\033[0m"
    fi
}

function makeIfAbsent {
    if ! [ -e "$1" ]
    then
        echo -e "\033[31mMissing \033[36m$1\033[31m directory, creating....\033[0m"
        mkdir --verbose --parent "$1"
    fi
}


cleanRunes
newRunes || exit 0

echo -e "\033[33mCasting Runes...\033[0m"

for rune in "${runes[@]}";
do
    IFS=',' read -r link file <<< "${rune}"
    if [ -d "$file" ]
    then
        makeIfAbsent "$link"
        for f in "$file"/*
        do
            linkRune "$f" "$link/$(basename "$f")"
        done
    else
        makeIfAbsent "$(dirname "$link")"
        linkRune "$file" "$link"
    fi
done
echo -e "\033[33mDone!\033[0m"
