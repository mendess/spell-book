#!/bin/bash

#shellcheck source=/home/mendess/.local/bin/library
. library
BACKUPS=~/Dropbox/backups

[ -e "$BACKUPS" ] || exit 1

mkdir -p "$LINKS"

for data in "$BACKUPS"/*.data
do
    linkname="${LINKS}/$(basename "$data" .data)"
    if ! [ -e "$linkname" ]
    then
        echo -en "\033[35mLinking "
        ln -sfv "$data" "$linkname"
        echo -en "\033[0m"
    fi
done

for data in "$LINKS"/*
do
    if [ -h "$data" ] && ! [ -e "$data" ]
    then
        echo -e "\033[31mRemoving dead link: $(basename "$data")\033[0m"
        rm "$data"
    fi
done
