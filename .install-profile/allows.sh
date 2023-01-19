#!/bin/bash

profiles_folder=$(dirname -- "$0")

script="$1"
want_to_install="$2"

! [ -e "$profiles_folder/$script.profile" ] ||
    grep --line-regexp \
        --quiet \
        --extended-regexp \
        --file="$profiles_folder/$script.profile" \
        <<<"$want_to_install"
