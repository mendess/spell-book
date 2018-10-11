#!/bin/bash
echo -e "\033[34mBack me up inside\033[0m"

cd ~/gitProjects/spells

mkdir -p runes

runeList=( ~/.vimrc ~/.zshrc ~/.config/nvim/init.vim)

for rune in "${runeList[@]}";
do
    echo $rune
    cp $rune runes/
done

git add runes/*
git commit -m"Backup runes"
git push

if [[ $? == 1 ]];
then
    echo -e "\033[31mCan't backup\033[0m"
else
    echo -e "\033[32mBack me up and save me"
fi
