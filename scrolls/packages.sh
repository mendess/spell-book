#!/bin/bash
# List of important packages

export packages=(
acpi
alacritty
alsa-utils
base
base-devel
bat
bc
bottom
clang
cmake
cronie
curl
dash
direnv
discord
duf
dunst
dust
entr
exa
fakeroot
firefox
fzf
gdb
gimp
git-delta
htop
hyprland
imagemagick
inotify-tools # power mode checking in lemonbar
jq
khal
man
man-pages
mpv
neovim
nmap
noto-fonts-cjk
noto-fonts-emoji
nsxiv
openssh
pkgconf
pulseaudio
pulseaudio-alsa
pulseaudio-bluetooth
python-dbus
python-pip
python-pygments
ripgrep
rsync
rustup
socat
tmux
ttf-dejavu
ttf-hack
unzip
vdirsyncer
wget
wl-clipboard
xdg-user-dirs
xh
xz
zathura
zathura-pdf-mupdf
zip
)

[[ "$(hostname)" = tolaria ]] || packages+=(brightnessctl)

export aurpackages=(
pacmixer
pfetch
shellcheck-bin
termsyn-font
web-xdg-open-git
freetube-bin
swaylock-effects
swhkd-git
)

export cargopackages=(
cargo-watch
color_picker
rust-script
)

export bloat=(
nano
vim
xorg-xclock
)

export pythonpackages=(
pynvim
)
