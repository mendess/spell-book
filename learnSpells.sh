#!/bin/bash

mkdir -p ~/.local/bin

cd $(dirname "$(realpath $0)")

for spell in *.sh
do
    if [[ ! -e ~/.local/bin/$(basename $spell .sh) ]]
    then
        echo -e "\e[38;2;138;93;150mLearning "$(basename $spell)"\e[0m"
        ln -sv $(pwd)"/"$spell ~/.local/bin/$(basename $spell .sh)
    fi
done
    
    
