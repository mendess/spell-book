command -V m &>/dev/null &&
    [[ "$(file "$(realpath "$(which m)")")" = *ELF* ]] &&
    . <(m auto-complete bash)
