#!/bin/bash

set -e
if [ "$#" = 0 ]; then
    ALL=1
else
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            -p | --pacman)
                PACMAN=1
                shift
                ;;
            -a | --aur)
                AUR=1
                shift
                ;;
            -c | --cargo)
                CARGO=1
                shift
                ;;
            -y | --python)
                PYTHON=1
                shift
                ;;
        esac
    done
fi

function pac() {
    [ "$ALL" = 1 ] || [ "$PACMAN" = 1 ]
}

function aur() {
    [ "$ALL" = 1 ] || [ "$AUR" = 1 ]
}

function carg() {
    [ "$ALL" = 1 ] || [ "$CARGO" = 1 ]
}

function pytho() {
    [ "$ALL" = 1 ] || [ "$PYTHON" = 1 ]
}

script_dir="$(dirname "$(realpath "$0")")"

#shellcheck source=/home/mendess/.bash_profile
. "$script_dir/../runes/bash/profile"

packages=()
aurpackages=()
bloat=()
cargopackages=()
pythonpackages=()
#shellcheck source=/home/mendess/Projects/spell-book/scrolls/packages.sh
. "$script_dir"/packages.sh

read -r -s -p "[sudo] password for $LOGNAME: " PASSWORD

echo "$PASSWORD" | sudo -S true
pac && sudo pacman -S --quiet --noconfirm --downloadonly --needed "${packages[@]}"

echo "$PASSWORD" | sudo -S true
pac && sudo pacman -S --quiet --noconfirm --needed "${packages[@]}"

pac && for package in "${bloat[@]}"; do
    if [ "$(pacman -Q --quiet "$package")" = "$package" ]; then
        echo "$PASSWORD" | sudo -S true
        sudo pacman -Rsn --noconfirm "$package"
    fi
done

pac && [ ! -e /usr/bin/scrot ] && {
    echo "$PASSWORD" | sudo -S true
    pacman -Q --quiet scrot && pacman -Rsn scrot
    git clone https://github.com/BeMacized/scrot
    cd scrot || exit 1
    ./configure
    make
    echo "$PASSWORD" | sudo -S true
    sudo make install
    cd .. || exit 1
    rm -rf scrot
}

# Dash
echo "$PASSWORD" | sudo -S true
pac && sudo ln -sf /usr/bin/dash /usr/bin/sh

# Zathura as default pdf reader
xdg-mime default org.pwmt.zathura.desktop application/pdf

# (AUR manager)
aur && {
    mkdir tmp
    cd tmp || exit 1
    for i in "${aurpackages[@]}"; do
        [ "$(pacman -Qq "$i")" = "$i" ] && continue
        old="$(pwd)"
        git clone https://aur.archlinux.org/"$i"
        cd "$i" || exit 1
        echo "$PASSWORD" | sudo -S true
        makepkg --syncdeps --install --noconfirm --skippgpcheck --clean
        cd "$old" || exit 1
    done
    cd ..
    rm -rf tmp
}

## NEOVIM
pac && nvim -c PlugInstall -c qall

carg && {
    rustup default stable
    cargo install --force "${cargopackages[@]}"
}

pytho && {
    pip install --user "${pythonpackages[@]}"
}
cd "$script_dir" || exit 1
../spells/syncspellbook.spell
