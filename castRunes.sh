#!/bin/bash

cd "$(dirname "$(realpath "$0")")""/runes" || exit 1

runes=(
~/.zprofile,zprofile
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
~/.Rider2018.3/config/idea.properties,idea.properties
)

expandedRunes=()

function expand {
    for file in "$2"/*
    do
        f="$(basename "$file")"
        if [ -d "$file" ]
        then
            expand "$1/$f" "$2/$f"
        else
            expandedRunes+=("$1/$f,$2/$f")
        fi
    done
}

for rune in "${runes[@]}"
do
    IFS=',' read -r link file <<< "${rune}"
    if [ -d "$link" ]
    then
        expand "$link" "$file"
    else
        expandedRunes+=("$rune")
    fi
done

function cleanRunes {
    local rune link file
    for rune in "${expandedRunes[@]}"
    do
        IFS=',' read -r link file <<< "${rune}"
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
    for rune in "${expandedRunes[@]}"
    do
        IFS=',' read -r link file <<< "${rune}"
        [ -h "$link" ] || return 0
    done
    return 1
}

function linkRune {
    if ! [ -h "$2" ]
    then
        echo -en "\033[35mCasting "
        ln -s -v "$(pwd)/$1" "$2"
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

for rune in "${expandedRunes[@]}";
do
    IFS=',' read -r link file <<< "${rune}"
    makeIfAbsent "$(dirname "$link")"
    linkRune "$file" "$link"
done
echo -e "\033[33mDone!\033[0m"
