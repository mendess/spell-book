#!/usr/bin/env bash

allows="$(dirname -- "$0")/.install-profile/allows.sh stolenMagic"

mapfile -t scripts < <(echo "
https://raw.githubusercontent.com/matildeopbravo/dotfiles/master/scripts/f
https://raw.githubusercontent.com/matildeopbravo/dotfiles/master/scripts/vim-anywhere
https://raw.githubusercontent.com/JoseFilipeFerreira/toolbelt/master/toolbox/qrwifi.tool
https://raw.githubusercontent.com/JoseFilipeFerreira/toolbelt/master/toolbox/cuffs.tool
https://raw.githubusercontent.com/JoseFilipeFerreira/toolbelt/master/powertools/thonkbar/scripts/platform_profile
" | xargs --no-run-if-empty -I {} bash -c "$allows \"\$(basename {})\" && echo {}")

user-from-link() {
    cut -d/ -f4
}

install-script() {
    (
        cd ~/.local/bin/
        wget --quiet -N "$1" |& grep -v ^SSL_INIT$
        chmod +x "$(basename "$1")"
        echo "  - $(basename "$1")"
    )
}

if [[ "${#scripts[@]}" -eq 0 ]]; then
    exit 0
fi

printf "\n\033[33mStealing magic from \033[1m%s\033[0;33m users\033[0m\n" \
    $(printf "%s\n" "${scripts[@]}" | user-from-link | sort -u | wc -l)

for s in "${scripts[@]}"; do
    install-script "$s" &
done
wait

printf "\n\033[33mDone!\033[0m\n"
