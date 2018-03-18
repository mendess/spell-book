#!/bin/bash
while true;
do
    echo -ne "\033[34m Building...\033[0m"
    pdflatex --halt-on-error --shell-escape Report.tex > /dev/null
    for i in {0..27}; do echo -ne "\b"; done;
    if [ $? -eq 0 ]
    then
        echo -e "\033[32m Built without errors!\033[0m"
    else
        echo -e "\033[31m Couldn't build properly. Check your tex\033[0m"
    fi;
    echo -en "\033[33m Rebuilding in: \033[0m"
    for i in {30..0}
    do
        if [ $i -lt 10 ]
        then
            echo -n "0"
        fi;
        echo -n $i"  "
        sleep 1s
        echo -en "\b\b\b\b"
    done;
    clear;
done;
