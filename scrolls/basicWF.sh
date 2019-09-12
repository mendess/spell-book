#!/bin/bash

echo "$#"
exit

script_dir="$(dirname "$(realpath "$0")")"

packages=()
aurpackages=()
bloat=()
cargopackages=()
eval "$(cat "$script_dir"/packages.sh)"

sudo pacman -S  "${packages[@]}"

sudo pacman -Rsn "${bloat[@]}"
exit

## NEOVIM
pip3 install --user pynvim
pip3 install --user --upgrade pynvim

nvim -c PlugInstall -c qall

#Oh My Zsh
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# Yay (AUR manager)
cd /tmp || exit 1
git clone https://aur.archlinux.org/yay.git
cd yay || exit 1
makepkg -s

yay -S "${aurpackages[@]}"

cargo install "${cargopackages[@]}"

# Compton
sudo pacman -S libconfig libxdg-basedir asciidoc
cd /tmp || exit 1
git clone https://github.com/tryone144/compton
cd compton || exit 1
make
make docs
sudo make install

cd "$script_dir" || exit 1
../spells/syncspellbook.spell
