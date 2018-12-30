#!/bin/bash

if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <link>"
    exit 1
fi

cd "$(dirname "$(realpath "$0")")" || exit 1
echo "$(youtube-dl --get-title "$1");$1" >> ../cantrips/links
