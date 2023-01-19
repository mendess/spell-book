#!/bin/bash

profiles_folder=$(dirname -- "$0")

script="$1"
want_to_install="$2"

! [ -e "$profiles_folder/$script.profile" ] ||
    {
        while read -r pattern; do
            grep -qE "^$pattern$" <<<"$want_to_install" && exit 0
        done < "$profiles_folder/$script.profile"
        exit 1
    }
