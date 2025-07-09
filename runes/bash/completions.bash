#!/bin/bash

_za() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    mapfile -t COMPREPLY < \
        <(compgen -o plusdirs -A file -- "$cur" | grep -P '(\.djvu|\.pdf)$')
    return
}

_za() {
    local cur files
    cur="${COMP_WORDS[COMP_CWORD]}"
    if [ -d "$cur" ]; then
        find_target="$cur"
    elif [ -d "$(readlink "${cur/\/$/}")" ]; then
        find_target="$(readlink "${cur/\/$/}")"
    elif [ -d "$(dirname "$cur")" ]; then
        find_target="$(dirname "$cur")"
    elif [ -d "$(readlink "$(dirname "$cur")")" ]; then
        find_target="$(readlink "$(dirname "$cur")")"
    else
        find_target="."
    fi
    echo "ft: '$find_target'" >/dev/pts/9
    pushd "$find_target" &>/dev/null || return 0
    files=$(find . -maxdepth 1 -type f 2>/dev/null |
        grep -P '(\.djvu|\.pdf)$' |
        sed "s|^./|$find_target/|g" |
        sed 's|//|/|g')
    popd &>/dev/null || return 0
    echo "f: '$files'" >/dev/pts/9
    declare -a completions
    mapfile -t completions < <(compgen -o plusdirs -W "$(printf '%q ' "${files[@]}")" -- "$cur")
    local comp
    COMPREPLY=()
    for comp in "${completions[@]}"; do
        COMPREPLY+=("$(printf "%q" "$comp")")
    done
    if [ "${#COMPREPLY[@]}" = 1 ]; then
        sug="${COMPREPLY[0]}"
        echo "s: '$sug'" >/dev/pts/9
        if [ -d "$(readlink "$sug")" ]; then
            pushd "$sug" &>/dev/null || return 0
            files=("$(find . -type f -maxdepth 1 2>/dev/null |
                grep -P '(\.djvu|\.pdf)$' |
                sed "s|^./|$sug/|g")")
            pwd >/dev/pts/9
            popd &>/dev/null || return
            echo "f2: '${files[*]}'" >/dev/pts/9
            unset completions
            declare -a completions
            mapfile -t completions < \
                <(compgen -o plusdirs -W "$(printf '%q ' "${files[@]}")" -- "$cur")
            local comp
            COMPREPLY=()
            for comp in "${completions[@]}"; do
                COMPREPLY+=("$(printf "%q" "$comp")")
            done
        fi
    fi
    return
}

_path_compleation() {
    [[ $COMP_CWORD = 1 ]] &&
        mapfile -t COMPREPLY < <(compgen -A function -ac -- "$2")
}

complete -o default -F _path_compleation sudo
complete -o default -F _path_compleation which
complete -o default -F _path_compleation command

_completion_loader() {
    case "$1" in
        g|gco|gb|gl|gd)
            cmd=git
            ;;
        # broken completions
        mpv)
            cmd="this-is-broken-$1"
            ;;
        *)
            cmd=$1
            ;;
    esac
    personal="$SPELLS/runes/bash/completions/$cmd.bash"
    global="/usr/share/bash-completion/completions/$cmd"
    [ -f "$personal" ] && . "$personal" >/dev/null 2>&1 && return 124
    [ -f "$global" ] && . "$global" >/dev/null 2>&1 && return 124
}
complete -D -F _completion_loader -o bashdefault -o default
