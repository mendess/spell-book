#!/bin/bash
sudo pacman -S neovim
pip3 install --user pynvim
pip3 install --user --upgrade pynvim

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim -c PlugInstall -c qall
