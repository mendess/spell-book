#!/bin/bash

mkdir -p .install-profile/

cd "$(dirname $(realpath "$0"))" || exit 0

for s in *.sh; do
    [[ $(realpath "$0") = $(realpath "$s") ]] && continue
    [[ -x "$s" ]] || continue
    echo "disabling $s"
    touch .install-profile/"$(basename "$s" .sh).profile"
done
