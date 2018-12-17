#!/bin/bash

if git --version &>/dev/null
then
    git config --global user.name "Mendess2526"
    git config --global user.email "pedro.mendes.26@gmail.com"
    git config --global core.excludesfile '~/.gitignore-global'
else
    echo Please install git
fi
