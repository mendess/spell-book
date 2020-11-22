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
gimp
glava
hacksaw shotgun
hyperfine
imagemagick
jq
khal
libconfig # compton dependency
libxdg-basedir # compton dependency
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
ttf-nerd-fonts-symbols # sway-launcher-desktop dependency
unzip
urxvt-perls
usbutils
vdirsyncer
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
xwallpaper
xz
youtube-dl
zathura
zathura-pdf-mupdf
zip
)

[[ "$(hostname)" =~ weatherlight|matess ]] && packages+=(brightnessctl)

export aurpackages=(
#dropbox
#dropbox-cli
entr
htop-vim-git
lemonbar-xft-git
pacmixer
pfetch
picom-git
shellcheck-static
xdo-git
termsyn-font
bear
web-xdg-open-git
delta-git-bin
)

export cargopackages=(
#tealdeer
cargo-watch
color_picker
colo
)

export bloat=(
nano
vim
xorg-xclock
)

export pythonpackages=(
dbus-python
yeelight
pynvim
yapf
)
