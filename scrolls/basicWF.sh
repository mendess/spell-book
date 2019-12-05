#!/bin/bash

if [ "$#" = 0 ]
then
    ALL=1
else
    while [[ $# -gt 0 ]]
    do
    key="$1"

    case $key in
        -p|--pacman)
        PACMAN=1
        shift
        ;;
        -a|--aur)
        AUR=1
        shift
        ;;
        -z|--zsh)
        ZSH=1
        shift
        ;;
        -c|--cargo)
        CARGO=1
        shift
    esac
    done
fi

function pac {
    test "$ALL" = 1 || test "$PACMAN" = 1
}

function aur {
    test "$ALL" = 1 || test "$AUR" = 1
}

function zsh {
    test "$ALL" = 1 || test "$ZSH" = 1
}

function carg {
    test "$ALL" = 1 || test "$CARGO" = 1
}

script_dir="$(dirname "$(realpath "$0")")"

packages=()
aurpackages=()
bloat=()
cargopackages=()
#shellcheck source=/home/mendess/Projects/spell-book/scrolls/packages.sh
. "$script_dir"/packages.sh

pac && yes | sudo pacman -S --needed  "${packages[@]}"

pac && yes | sudo pacman -Rsn "${bloat[@]}"

## NEOVIM
pac && nvim -c PlugInstall -c qall

# (AUR manager)
aur && {
    #shellcheck source=/home/mendess/.bashrc
    source ~/.bashrc
    for i in "${aurpackages[@]}"
    do
        aura -S "$i"
    done
}

carg && cargo install "${cargopackages[@]}"

# Compton
pac && {
yes | sudo pacman -S --needed libconfig libxdg-basedir asciidoc
cd /tmp || exit 1
git clone https://github.com/tryone144/compton
cd compton || exit 1
make
make docs
sudo make install
}

pac && sudo ln -sf /usr/bin/dash /usr/bin/sh

cd "$script_dir" || exit 1
#../spells/syncspellbook.spell
