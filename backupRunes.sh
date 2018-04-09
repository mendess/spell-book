#!/bin/bash

cd ~/gitProjects/spells

mkdir -p runes
cp ~/.vimrc runes/
cp ~/.zshrc runes/

git add runes/
git commit -m"Backup runes"
git push
