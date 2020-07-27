#!/bin/bash
#shellcheck disable=2155

## Option docs:
## - sudo: Require sudo to install the dotfiles
## - generated: Dotfile is generated based on host
## - ifdir: Only install if it's directory already exists

any_match() {
    local i
    for i in "${@:2}"; do
        [ "$i" = "$1" ] && return
    done
    return 1
}

join_by() {
    local IFS="$1"
    shift
    echo "$*"
}

sudoHost() {
    local h
    for h in tolaria weatherlight mirrodin; do
        [ "$(hostname)" = "$h" ] && return 0
    done
    return 1
}

if ! sudoHost; then
    sudo() {
        echo "sudo not available"
    }
fi

if hash library 2>/dev/null; then
    #shellcheck source=/home/mendess/.local/bin/library
    . library

    cd "$SPELLS/runes" || exit 1
else
    cd "$(dirname "$0")"/runes || exit 1
fi

expandedRunes=()

expand() {
    local file f
    for file in "$2"/*; do
        f="$(basename "$file")"
        if [ -d "$file" ]; then
            expand "$1/$f" "$2/$f" "$3"
        else
            expandedRunes+=("$1/$f,$2/$f,$3")
        fi
    done
}

while IFS=',' read -r -a args; do
    link="${args[0]}"
    file="${args[1]}"
    args[0]="${args[0]/#\~/$HOME}"
    if [ -d "$file" ]; then
        expand "${args[@]}"
    else
        expandedRunes+=("$(join_by ',' "${args[@]}")")
    fi
done < <(sed '/^#/d' ../runes/.db)

cleanRunes() {
    local rune
    for rune in "${expandedRunes[@]}"; do
        local link file
        IFS=',' read -r link file <<<"${rune}"
        if [ -h "$link" ] && ! [ -e "$link" ]; then
            echo -e "\033[31mRemoving broken rune: $(basename "$link")\033[0m"
            rm "$link"
        fi
    done
    return 1
}

newRunes() {
    local rune
    for rune in "${expandedRunes[@]}"; do
        local args link
        IFS=',' read -r -a args <<<"${rune}"
        link="${args[0]}"
        local ifdir=""
        local generated=""
        any_match sudo "${args[@]:2}" && ! sudoHost && continue
        any_match ifdir "${args[@]:2}" && ifdir=1
        any_match generated "${args[@]:2}" && echo "generated for $link" && generated=1
        [ "$ifdir" ] && [ ! -e  "$(dirname "$link")" ] && continue
        if [ "$generated" ]; then
            [ ! -e "$link" ]
        else
            [ ! -h "$link" ]
        fi && return 0
    done
    return 1
}

linkRune() {
    local generated force
    any_match generated "${@:3}" && generated=1
    any_match force "${@:3}" && force=1
    [ "$generated" ] && [ "$force" ] &&
        echo -e '\e[33mWarning:\e[0m Forced does nothing when combined with generated'
    local target="$(pwd)/$1"
    local link_name="$2"
    if [ ! -h "$2" ] || { [ "$generated" ] && [ "$target" -ot "$link_name" ]; }; then
        if [ "$generated" ]; then
            local cmd=("python3" "$(pwd)/../generate_config.py" "$target" "$link_name")
        elif [ "$force" ]; then
            local cmd=(ln --symbolic --force --verbose "$target" "$link_name")
        else
            local cmd=(ln --symbolic --verbose "$target" "$link_name")
        fi
        if any_match sudo "${@:3}"; then
            echo "sudo for '$link_name'"
            echo -en "\033[35mCasting "
            sudo "${cmd[@]}"
        else
            echo -en "\033[35mCasting "
            "${cmd[@]}"
        fi
        echo -en "\033[0m"
    fi
}

makeIfAbsent() {
    if [ ! -e "$1" ]; then
        any_match ifdir "${@:2}" && return 1
        echo -e "\033[31mMissing \033[36m$1\033[31m directory, creating....\033[0m"
        mkdir --parent "$1"
    fi
    return 0
}

cleanRunes
newRunes || exit 0

echo -e "\033[33mCasting Runes...\033[0m"

for rune in "${expandedRunes[@]}"; do
    IFS=',' read -r -a args <<<"${rune}"
    link="${args[0]}"
    file="${args[1]}"
    if makeIfAbsent "$(dirname "$link")" "${args[@]:2}"; then
        linkRune "$file" "$link" "${args[@]:2}"
    fi
done
echo -e "\033[33mDone!\033[0m"
