#!/bin/bash

packages=(
alsa-utils
bc
clang
cmake
compton
cronie
curl
dash
dmenu
dunst
entr
feh
firefox
gdb
gimp
gparted
htop
i3-gaps
i3lock
i3status
imagemagick
jq
mpv
neofetch
network-manager-applet
nitrogen
nmap
noto-fonts-emoji
openssh
parted
pkgconf
pulseaudio
pulseaudio-alsa
pulseaudio-bluetooth
pygmentize
python-pip
python-pygments
rsync
rtv
rxvt-unicode
scrot
shellcheck
socat
surf
sxiv
tmux
tree
ttf-dejavu
unzip
urxvt-perls
wget
xclip
xorg-server
xorg-xrandr
xz
zathura
zip
zsh
)

aurpackages=(
dropbox
dropbox-cli
discord
entr
fortune-mod
ncpamixer
pacmixer
toilet
urxvt-resize-font-git
shellcheck-static
)

cargopackages=(
tealdeer
hyperfine
exa
bat
)

bloat=(
nano
)

sudo pacman -S  "${packages[@]}"

sudo pacman -Rsn "${bloat[@]}"

## NEOVIM
pip3 install --user pynvim
pip3 install --user --upgrade pynvim

nvim -c PlugInstall -c qall

#Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Rust
curl https://sh.rustup.rs -sSf | sh

# Rua (AUR manager)
cd /tmp || exit 1
git clone https://aur.archlinux.org/rua.git
cd rua || exit 2
makepkg -si

rua install "${aurpackages[@]}"

cargo install "${cargopackages[@]}"

../spells/syncspellbook.spell
