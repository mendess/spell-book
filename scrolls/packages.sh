#!/bin/bash
# List of important packages

export packages=(
acpi
alacritty
alsa-utils
asciidoc # compton dependency
base
base-devel
bat
bc
herbstluftwm
clang
clipmenu
cmake
cronie
brightnessctl
curl
dash
discord
dmenu
dunst
entr
exa
fakeroot
feh
firefox
fortune-mod
fzf
gdb
gimp
glava
hacksaw
htop
hyperfine
i3lock
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
python-dbus
python-pip
python-pygments
ripgrep
rsync
rtv
rustup
shfmt
shotgun
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
vdirsyncer
vimb
wget
xclip
xdg-user-dirs
xdotool
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
lemonbar-xft-git
pacmixer
pfetch
picom-git
shellcheck-bin
xdo-git
termsyn-font
bear
web-xdg-open-git
git-delta-bin
)

export cargopackages=(
#tealdeer
cargo-watch
color_picker
)

export bloat=(
nano
vim
xorg-xclock
)

export pythonpackages=(
pynvim
yapf
)
