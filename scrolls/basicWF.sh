#!/bin/bash

if [ "$#" = 0 ]; then
    ALL=1
else
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            pacman | -p | --pacman)
                PACMAN=1
                ;;
            aur | -a | --aur)
                AUR=1
                ;;
            cargo | -c | --cargo)
                CARGO=1
                ;;
            python | -y | --python)
                PYTHON=1
                ;;
        esac
        shift
    done
fi

pac() { [ "$ALL" = 1 ] || [ "$PACMAN" = 1 ]; }
aur() { [ "$ALL" = 1 ] || [ "$AUR" = 1 ]; }
carg() { [ "$ALL" = 1 ] || [ "$CARGO" = 1 ]; }
pytho() { [ "$ALL" = 1 ] || [ "$PYTHON" = 1 ]; }

script_dir="$(dirname "$(realpath "$0")")"

#shellcheck source=/home/mendess/.bash_profile
. "$script_dir/../runes/bash/profile"

packages=()
aurpackages=()
bloat=()
cargopackages=()
pythonpackages=()
#shellcheck source=/home/mendess/projects/spell-book/scrolls/packages.sh
. "$script_dir"/packages.sh

sudo() { echo "$PASSWORD" | command sudo -S true && command sudo "$@"; }

read -r -s -p "[sudo] password for $LOGNAME: " PASSWORD

pac && sudo pacman -S --quiet --noconfirm --needed "${packages[@]}"

pac && for package in "${bloat[@]}"; do
    [ "$(pacman -Q --quiet "$package")" = "$package" ] &&
        sudo pacman -Rsn --noconfirm "$package"
done

# Dash
pac && sudo ln -sf /usr/bin/dash /usr/bin/sh

# (AUR manager)
aur && {
    mkdir tmp
    (
        cd tmp || exit 1
        git clone https://github.com/jtexeira/tiny-aura.git
        (cd tiny-aura || exit 1 && sudo make)
        for i in "${aurpackages[@]}"; do
            pacman -Qq "$i" || (
                echo "INSTALLING AUR PKG: $i"
                git clone https://aur.archlinux.org/"$i"
                cd "$i" || exit 1
                echo "$PASSWORD" | command sudo -S true
                makepkg --syncdeps --install --noconfirm --skippgpcheck --clean
            )
        done
    )
    rm -rf tmp
}

## NEOVIM
pac && nvim -c PlugInstall -c qall

carg && {
    rustup default stable &&
        cargo install --force "${cargopackages[@]}"
}

pytho && {
    sudo pip install "${pythonpackages[@]}"
}

sudo systemctl enable cronie
sudo systemctl enable NetworkManager

cd "$script_dir" || exit 1
../spells/update_rust_analyzer.spell
../spells/syncspellbook.spell --nocommit
