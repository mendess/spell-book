#!/bin/bash
cd /tmp
git clone https://aur.archlinux.org/package-query
cd package-query
makepkg -s
sudo pacman -U package-query-1.9-3-x86_64.pkg.tar.xz
cd ..
git clone https://aur.archlinux.org/yaourt.git
cd yaourt
makepkg -s
sudo pacman -U yaourt-1.9-1-any.pkg.tar.xz
