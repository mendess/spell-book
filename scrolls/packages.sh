#!/bin/bash

export packages=(
acpi
alacritty
alsa-utils
asciidoc # compton dependency
bat
bc
bspwm
clang
clipmenu
cmake
cronie
curl
dash
discord
dmenu
dunst
entr
exa
feh
firefox
fortune-mod
fzf
gdb
giblib # scrot deps
gimp
glava
hyperfine
imagemagick
jq
libconfig # compton dependency
libxdg-basedir # compton dependency
lynx
man
man-pages
mpv
neofetch
neovim
network-manager-applet
nmap
noto-fonts-cjk
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
ripgrep
rsync
rtv
rustup
shfmt
socat
sxhkd
sxiv
tmux
tree
ttf-dejavu
ttf-hack
unzip
urxvt-perls
usbutils
vimb
wget
xclip
xdg-user-dirs
xorg-server
xorg-xdpyinfo
xorg-xev
xorg-xinit
xorg-xrandr
xorg-xsetroot
xz
youtube-dl
zathura
zathura-pdf-poppler
zip
)

export aurpackages=(
dropbox
dropbox-cli
entr
htop-vim-git
lemonbar-xft-git
ncpamixer
pacmixer
picom-tryone-git
polybar
shellcheck-static
toilet
xdo-git
)

export cargopackages=(
#tealdeer
cargo-watch
#racer
)

export bloat=(
nano
vim
xorg-xclock
)

export pythonpackages=(
dbus-python
yeelight
)
