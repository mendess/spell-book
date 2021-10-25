#!/bin/sh
git submodule update --init --recursive
m_installed() {
    f="$(readlink ~/.local/bin/m)" && [ -e "$f" ]
}
m() {
    mkdir -p ~/.local/bin/
    ln -svf "$1"/m.sh ~/.local/bin/m
}

lemons_installed() { (
    cd "$1" &&
        command -V lemon 2>/dev/null >/dev/null &&
        [ "$(awk -F'"' '/version/ {print $2; exit(0)}' Cargo.toml)" = "$(lemon --version | awk '{print $2}')" ]
); }

lemons() { (
    rustup show | grep -q 'no active toolchain' &&
        return
    cd "$1" &&
        cargo install --path . --bin lemon
); }

all_installed() {
    find library/ -mindepth 1 -maxdepth 1 -type d |
        while read -r l; do
            "$(basename "$l")_installed" "$(pwd)/$l" || return 1
        done
}

all_installed && exit

printf "\033[33mReading Books...\033[0m\n"

find library/ -mindepth 1 -maxdepth 1 -type d |
    while read -r l; do
        #shellcheck disable=2091
        "$(basename "$l")_installed" "$(pwd)/$l" || "$(basename "$l")" "$(pwd)/$l"
    done

printf "\033[33mDone!\033[0m\n"
