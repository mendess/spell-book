#!/bin/bash

echo -e "\n\033[33m Learning Spells...\033[0m\n"
mkdir -p ~/.local/bin

cd $(dirname "$(realpath $0)")

for spell in *.sh
do
    if ! [ -e ~/.local/bin/$(basename $spell .sh) ]
    then
        echo -e "\e[38;2;138;93;150mLearning "$(basename $spell)"\e[0m"
        ln -sv $(pwd)"/"$spell ~/.local/bin/$(basename $spell .sh)
    else
        echo -e "\033[36m"$spell"\033[32m already learned, skipping...\033[0m"
    fi
done
    
    
