#!/bin/bash

echo -e "\n\033[33mLearning Spells...\033[0m"
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
echo -e "\033[33mDone!\033[0m"
