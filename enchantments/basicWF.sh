#!/bin/bash

packages=( openssh htop curl wget numlockx xclip tree )

sudo pacman -S --noconfirm "${packages[@]}"
