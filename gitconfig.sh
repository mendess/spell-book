#!/bin/bash

if git --version
then
    git config --global user.name "Mendess2526"
    git config --global user.email "pedro.mendes.26@gmail.com"
    git config --global core.excludesfile '~/.gitignore'
fi
