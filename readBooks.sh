#!/bin/bash
git submodule update --init --recursive

allows="$(dirname -- "$0")/.install-profile/allows.sh readBooks"

rust_is_setup() {
    set -o pipefail
    command -V cargo &>/dev/null &&
        ! rustup show 2>/dev/null | grep -q 'no active toolchain'
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
m() (
    cd "$1" &&
        cargo install --path . --bin m
)

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

foretell_installed() (
    rust_is_setup || return 0
    cd "$1" &&
        command -V foretell 2>/dev/null >/dev/null &&
        up_to_date_rust_bin foretell
)
foretell() (
    cd "$1" &&
        cargo install --path . --bin foretell
)

find_missing() {
    find library/ -mindepth 1 -maxdepth 1 -type d |
        while read -r l; do
            book=$(basename "$l")
            if $allows "$book" && ! "${book}_installed" "$(pwd)/$l"; then
                 echo "$l"
            fi
        done
}

mapfile -t missing_books < <(find_missing)
if [ "${#missing_books[@]}" -eq 0 ]; then
    exit 0
fi

printf "\033[33mReading Books...\033[0m\n"

for l in "${missing_books[@]}"; do
    #shellcheck disable=2091
    "$(basename "$l")" "$(pwd)/$l"
done

printf "\033[33mDone!\033[0m\n"
