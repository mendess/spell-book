#!/bin/bash
sudo pacman -S --noconfirm zsh wget curl
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

../castRunes.sh
