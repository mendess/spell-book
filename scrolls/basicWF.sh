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
    test "$ALL" || "$PACMAN"
}

function aur {
    test "$ALL" || "$AUR"
}

function zsh {
    test "$ALL" || "$ZSH"
}

function carg {
    test "$ALL" || "$CARGO"
}

script_dir="$(dirname "$(realpath "$0")")"

packages=()
aurpackages=()
bloat=()
cargopackages=()
eval "$(cat "$script_dir"/packages.sh)"

pac && yes n | sudo pacman -S  "${packages[@]}"

pac && yes n | sudo pacman -Rsn "${bloat[@]}"

## NEOVIM
pac && pip3 install --user pynvim
pac && pip3 install --user --upgrade pynvim

pac && nvim -c PlugInstall -c qall

#Oh My Zsh
zsh && \
    curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh \
    | sh

# Yay (AUR manager)
aur && {
cd /tmp || exit 1
git clone https://aur.archlinux.org/yay.git
cd yay || exit 1
makepkg -s

yay -S "${aurpackages[@]}"
}

carg && cargo install "${cargopackages[@]}"

# Compton
pac && {
yes n | sudo pacman -S libconfig libxdg-basedir asciidoc
exit
cd /tmp || exit 1
git clone https://github.com/tryone144/compton
cd compton || exit 1
make
make docs
sudo make install
}

cd "$script_dir" || exit 1
../spells/syncspellbook.spell
