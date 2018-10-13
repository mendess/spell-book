#!/bin/bash

# runeList=( ~/.oh-my-zsh/custom/aliases.zsh ~/.config/nvim/init.vim )

echo -e "\033[34mBack me up inside\033[0m"

echo $(dirname `which $0`)
echo $(pwd -P)
cd $(dirname "$(realpath $0)")
pwd

git pull
git add runes/*
git add $(basename $0).sh
git commit -m"Backup runes | "$(date +%d/%m/%y)
git push

if [[ $? == 1 ]];
then
    echo -e "\033[31mCan't backup\033[0m"
else
    echo -e "\033[32mBack me up and save me"
fi
