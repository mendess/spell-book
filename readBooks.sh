#!/bin/sh
git submodule update --init --recursive

rust_is_setup() {
    ! rustup show | grep -q 'no active toolchain'
}

up_to_date_rust_bin() {
    cmd=$1
    new=$(awk -F'"' '/version/ {print $2; exit(0)}' Cargo.toml)
    curr=$(command "$cmd" --version | awk '{print $2}') && {
        [ "$new" = "$curr" ] ||
            [ "$(printf "%s\n%s" "$new" "$curr" | sort -V | tail -1)" = "$curr" ]
    }
}

m_installed() (
    rust_is_setup || return 0
    cd "$1" &&
        command -V m 2>/dev/null >/dev/null &&
        up_to_date_rust_bin m
)
m() {
    cd "$1" &&
        cargo install --path . --bin m
}

lemons_installed() (
    rust_is_setup || return 0
    cd "$1" &&
        command -V lemon 2>/dev/null >/dev/null &&
        up_to_date_rust_bin lemon
)
lemons() (
    cd "$1" &&
        cargo install --path . --bin lemon
)

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
