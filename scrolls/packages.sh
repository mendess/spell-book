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
bottom
clang
clipmenu
cmake
cronie
curl
dash
direnv
discord
dmenu
duf
dunst
dust
entr
exa
fakeroot
feh
firefox
fzf
gdb
gimp
git-delta
glava
hacksaw
herbstluftwm
htop
hyperfine
i3lock
imagemagick
inotify-tools # power mode checking in lemonbar
jq
khal
libconfig # compton dependency
libxdg-basedir # compton dependency
man
man-pages
mpv
neovim
nmap
noto-fonts-cjk
noto-fonts-emoji
openssh
parted
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
shfmt
shotgun
socat
sxhkd
nsxiv
tmux
tree
ttf-dejavu
ttf-hack
unzip
usbutils
vdirsyncer
vimb
wget
wl-clipboard
xclip
xdg-user-dirs
xdotool
xh
xorg-server
xorg-xdpyinfo
xorg-xev
xorg-xinit
xorg-xrandr
xz
zathura
zathura-pdf-mupdf
zip
)

[[ "$(hostname)" = tolaria ]] || packages+=(brightnessctl)

export aurpackages=(
lemonbar-xft-git
pacmixer
pfetch
picom-git
shellcheck-bin
xdo-git # herbstluftwm and bspwm
termsyn-font
#bear
web-xdg-open-git
yt-dlp-drop-in
)

export cargopackages=(
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
