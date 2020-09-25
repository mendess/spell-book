#!/bin/sh
git submodule update --init --recursive
m_installed() {
    f="$(readlink ~/.local/bin/m)" && [ -e "$f" ]
}
m() {
    ln -svf "$1"/m.sh ~/.local/bin/m
}

all_installed() {
    find library/ -mindepth 1 -maxdepth 1 -type d |
        while read -r l; do
            "$(basename "$l")_installed" || exit 1
        done
}

all_installed && exit

printf "\033[33mReading Books...\033[0m\n"

find library/ -mindepth 1 -maxdepth 1 -type d |
    while read -r l; do
        #shellcheck disable=2091
        "$(basename "$l")_installed" || "$(basename "$l")" "$(pwd)/library/m"
    done

printf "\033[33mDone!\033[0m\n"
