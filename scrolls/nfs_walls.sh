#!/bin/bash
# Create a network mounted filesystem for my wallpapers

sudo pacman -S --needed --noconfirm nfs-utils

if ! showmount -e mirrodin; then
    echo "please fix"
fi

mkdir -p ~/.local/share/wallpapers
sudo mount mirrodin:/Wallpapers .local/share/wallpapers
cat <<EOF | tee -a /etc/fstab
# /nfs/Wallpapers
mirrodin:/Wallpapers /home/mendess/.local/share/wallpapers nfs defaults,timeo=900,retrans=5,_netdev 0 0
EOF
