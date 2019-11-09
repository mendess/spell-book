#!/bin/bash

#shellcheck source=/home/mendess/.local/bin/library
. library

cd "$SPELLS/runes" || exit 1

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

while IFS=',' read -r link file options
do
    link="${link/#\~/$HOME}"
    if [ "$options" = "check" ]
    then
        # TODO: Check
        true
    fi
    if [ -d "$file" ]
    then
        expand "$link" "$file"
    else
        expandedRunes+=("$link,$file")
    fi
done < ../runes/.db

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
        mkdir --parent "$1"
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
