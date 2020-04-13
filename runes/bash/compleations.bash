#!/bin/bash

_za() {
    local curw
    curw=${COMP_WORDS[COMP_CWORD]}
    mapfile -t COMPREPLY < \
        <(compgen -o plusdirs -A file -- "$curw" | grep -P '(\.djvu|\.pdf)$')
    return
}

_za() {
    local curw files
    curw=${COMP_WORDS[COMP_CWORD]}
    if [ -d "$curw" ]; then
        find_target="$curw"
    elif [ -d "$(readlink "${curw/\/$/}")" ]; then
        find_target="$(readlink "${curw/\/$/}")"
    elif [ -d "$(dirname "$curw")" ]; then
        find_target="$(dirname "$curw")"
    elif [ -d "$(readlink "$(dirname "$curw")")" ]; then
        find_target="$(readlink "$(dirname "$curw")")"
    else
        find_target="."
    fi
    echo "ft: '$find_target'" > /dev/pts/9
    pushd "$find_target" &>/dev/null || return 0
    files=$(find . -maxdepth 1 -type f 2>/dev/null |
        grep -P '(\.djvu|\.pdf)$' |
        sed "s|^./|$find_target/|g" |
        sed 's|//|/|g')
    popd &>/dev/null || return 0
    echo "f: '$files'" >/dev/pts/9
    declare -a completions
    mapfile -t completions < <( compgen -o plusdirs -W "$(printf '%q ' "${files[@]}")" -- "$curw" )
    local comp
    COMPREPLY=()
    for comp in "${completions[@]}"; do
        COMPREPLY+=("$(printf "%q" "$comp")")
    done
    if [ "${#COMPREPLY[@]}" = 1 ]; then
        sug="${COMPREPLY[0]}"
        echo "s: '$sug'" > /dev/pts/9
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
                <( compgen -o plusdirs -W "$(printf '%q ' "${files[@]}")" -- "$curw" )
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
    local curw
    local files
    curw=${COMP_WORDS[COMP_CWORD]}
    files=$(find "$SPELLS" -type f | sed '/\.git/d ; s|'"$SPELLS"'/||g')
    mapfile -t COMPREPLY < <(compgen -W "$files" -- "$curw")
    return
}

complete -F _svim svim

_ssh() {
    local cur opts
    # local prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    #prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(grep '^Host' ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null | grep -v '[?*]' | cut -d ' ' -f 2-)
    mapfile -t COMPREPLY < <(compgen -W "$opts" -- "$cur")
    return 0
}

complete -F _ssh ssh

# _comp_java () {
#     prev=${COMP_WORDS[$COMP_CWORD - 1]}

#     case $prev in
#         "-jar")
#             COMPREPLY=($(compgen -A file -- ${COMP_WORDS[$COMP_CWORD]}))
#             ;;
#         *)
#             fields=($(echo ${COMP_WORDS[$COMP_CWORD]} | tr "." "\n"));
#             [ "${COMP_WORDS[$COMP_CWORD]: -1}" == "." ] && lastIdx=0 || lastIdx=1
#             [ ${#COMP_WORDS[$COMP_CWORD]} -eq 0 ] || [ ${lastIdx} -eq 0 ] && lastWord='' || lastWord=${fields[${#fields[@]}-1]}
#             [ ${#COMP_WORDS[$COMP_CWORD]} -eq 0 ] && fields=() || fields=($(echo ${fields[*]:0:${#fields[@]}-$lastIdx}))
#             [ ${lastIdx} -eq 0 ] && prefix=${COMP_WORDS[$COMP_CWORD]} || prefix=$(tr ' ' '.' <<< "$(echo "${fields[@]}.")")
#             [ "${prefix:0}" == "." ] && prefix=""

#             COMPREPLY=( $(compgen -W "$(ls $(tr ' ' '/' <<< $(echo ${fields[@]})))" -- $lastWord ))
#             COMPREPLY=(${COMPREPLY[@]/#/$prefix})
#             COMPREPLY=(${COMPREPLY[@]/%/.})
#             COMPREPLY=(${COMPREPLY[@]/.class./})
#             COMPREPLY=(${COMPREPLY[@]/.java./})
#             ;;
#     esac
#     return 0
# }

# complete -o nospace -o filenames -F _comp_java java
