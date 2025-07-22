#!/bin/bash
#git submodule update --init --recursive

allows="$(dirname -- "$0")/.install-profile/allows.sh readBooks"

_rust_is_setup() {
    set -o pipefail
    command -V cargo &>/dev/null &&
        ! rustup show 2>/dev/null | grep -q 'no active toolchain'
}

_up_to_date_rust_bin() {
    cmd=$1
    new=$(
        cargo metadata --quiet --format-version 1 |
            jq ".packages[] | select(.name == \"$1\") | .version" -r
    )
    curr=$(command "$cmd" --version | awk '{print $2}') && {
        [ "$new" = "$curr" ] ||
            [ "$(printf "%s\n%s" "$new" "$curr" | sort -V | tail -1)" = "$curr" ]
    }
}

_rust_installed() {
    _rust_is_setup || return 0
    cd "$1" &&
        command -V m 2>/dev/null >/dev/null &&
        _up_to_date_rust_bin "$2"
}

_rust_install() {
    cd "$1" &&
        cargo install --path . --bin "$2" "${@:3}"
}

m_installed() (
    _rust_installed "$1" m
)
m() (
    case "$(hostname)" in
        weatherlight|tolaria)
            enable_clipboard=("--features=clipboard")
            ;;
    esac
    _rust_install "$1" m "${enable_clipboard[@]}"
)

lemons_installed() (
    _rust_installed "$1" lemon
)
lemons() (
    _rust_install "$1" lemon
)

foretell_installed() (
    _rust_installed "$1" foretell
)
foretell() (
    _rust_install "$1" foretell
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
