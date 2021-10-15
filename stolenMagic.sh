#!/usr/bin/env bash

scripts=(
    https://raw.githubusercontent.com/matildeopbravo/dotfiles/master/scripts/f
    https://raw.githubusercontent.com/matildeopbravo/dotfiles/master/scripts/vim-anywhere
)

user-from-link() {
    cut -d/ -f4
}

install-script() {
    (
        cd ~/.local/bin/
        wget --quiet -N "$1" |& grep -v ^SSL_INIT$
        chmod +x "$(basename "$1")"
        echo "downloaded: $(user-from-link <<<"$1")/$(basename "$1")"
    )
}

printf "\n\033[33mStealing magic from:\033[0m\n"
printf "%s\n" "${scripts[@]}" | user-from-link | sort -u | while read -r user; do
    echo -e "  -> $user"
done
echo

for s in "${scripts[@]}"; do
    install-script "$s" &
done
wait

printf "\n\033[33mDone!\033[0m\n"
