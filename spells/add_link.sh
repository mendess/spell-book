#!/bin/bash

if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <name> <link>"
    exit 1
fi

cd "$(dirname "$(realpath "$0")")" || exit 1
echo "$1;$2" >> ../cantrips/links
