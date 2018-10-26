#!/bin/bash

echo -e "\n\033[33m Learning Spells...\033[0m"
mkdir -p ~/.local/bin

cd $(dirname "$(realpath $0)")

for spell in *.sh
do
    if ! [ -e ~/.local/bin/$(basename $spell .sh) ]
    then
        echo -e "\e[38;2;138;93;150mLearning "$(basename $spell .sh)"\e[0m"
        ln -sv $(pwd)"/"$spell ~/.local/bin/$(basename $spell .sh)
    fi
done
echo -e "\n\033[33m Done!\033[0m\n"
