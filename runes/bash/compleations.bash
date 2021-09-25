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

#complete -F _za za
#complete -F _za pdf

_svim() {
    local files
    local cur="${COMP_WORDS[COMP_CWORD]}"
    files=$(find "$SPELLS" -type f | sed '/\.git/d ; s|'"$SPELLS"'/||g')
    mapfile -t COMPREPLY < <(compgen -W "$files" -- "$cur")
    return
}

complete -F _svim svim

_ssh() {
    local opts
    # local prev
    local cur="${COMP_WORDS[COMP_CWORD]}"
    #prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(grep '^Host' ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null |
        grep -v '[?*]' |
        cut -d ' ' -f 2-)
    mapfile -t COMPREPLY < <(compgen -W "$opts" -- "$cur")
    return 0
}

complete -F _ssh ssh
complete -F _ssh sshp
complete -F _ssh deploy_to

_m() {
    for a in "$@"; do
        echo "a: $a"
    done
    local opts
    COMPREPLY=()
    local cur="$2"
    local prev="$3"
    case "$prev" in
        m | help)
            opts="$(m help |
                grep -Pv '^\t' |
                sed -E 's/([^ ]+) | ([^ ]+)/\1\n\2/g' |
                sed -E 's/(^.\s|\s.$|^.$)//g' |
                sed 's/?/-/g' |
                grep -v '^.$')"
            ;;
        *)
            local sub_command="${COMP_WORDS[1]}"
            if [[ "$sub_command" =~ q|queue|play ]] && [[ "$3" =~ -c|--category ]]; then
                opts="$(m cat | awk '{print $2}')"
            else
                opts="$(m help "$sub_command" | awk '
                            opts && /|/       { print $1" "$3 }
                            opts && $0 !~ /|/ { print $1 }
                            /Options/         { opts=1 }')"
                case "$sub_command" in
                    q | queue | play)
                        opts="$opts $(compgen -f)"
                        ;;
                esac
            fi
            ;;

    esac
    mapfile -t COMPREPLY < <(compgen -W "$opts" -- "$cur")
}

complete -F _m m

_path_compleation() {
    [[ $COMP_CWORD = 1 ]] &&
        mapfile -t COMPREPLY < <(compgen -A function -ac -- "$2")
}

complete -o default -F _path_compleation sudo
complete -o default -F _path_compleation which
complete -o default -F _path_compleation command

#shellcheck disable=SC1090
command -V arduino-cli &>/dev/null &&
    . <(arduino-cli completion bash) &&
    complete -o default -F __start_arduino-cli ard

completions_dir=/usr/share/bash-completion/completions/
[[ -f $completions_dir ]] &&
    for f in "$completions_dir"/*; do
        #shellcheck disable=1090
        . "$f"
    done

command -V youtube-dl &>/dev/null &&
    eval "$(sed 's/youtube-dl/ytdl/' < <(complete -p youtube-dl 2>/dev/null))"

for c in "$SPELLS"/runes/bash/compleations/*; do
    #shellcheck disable=1090
    . "$c"
done
