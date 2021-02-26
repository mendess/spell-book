#!/bin/bash
#shellcheck disable=2155
# Creates a sym-link for every rune in [runes](runes/). The location of the
# sym-link depends on the rune and is defined in the script.

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
    for h in tolaria weatherlight mirrodin matess kaladesh; do
        [ "$(hostname)" = "$h" ] && return 0
    done
    return 1
}

if ! sudoHost; then
    sudo() {
        echo "sudo not available"
    }
fi

if [[ "$SPELLS" ]]; then
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
            expand "$1/$f" "$2/$f" "${@:3}"
        else
            expandedRunes+=("$1/$f,$2/$f,${@:3}")
        fi
    done
}

while IFS=',' read -r -a args; do
    file="${args[1]}"
    link="${args[0]/#\~/$HOME}"
    [[ $link =~ .*\*.* ]] && {
        path="${link%%/*}"
        rest="${link#*/}"
        while [ "$rest" ]; do
            case "$rest" in
                */*)
                    seg="${rest%%/*}"
                    rest="${rest#*/}"
                    ;;
                *)
                    seg="$rest"
                    rest=""
                    ;;
            esac
            path="$path/$seg"
            #shellcheck disable=2206
            a=($path)
            [[ "${#a[@]}" -gt 1 ]] &&
                echo -e "too many matches: \n$(join_by "\n\t" "${a[@]}")" &&
                break
            path="${a[0]}"
        done
        [[ $path =~ .*\*.* ]] && continue
        link="$path"
    }
    args[0]="$link"
    if [ -d "$file" ]; then
        expand "${args[@]}"
    else
        expandedRunes+=("$(join_by ',' "${args[@]}")")
    fi
done < <(sed '/^#/d' ../runes/.db)

cleanRunes() {
    local rune
    for rune in "${expandedRunes[@]}"; do
        local link file args
        IFS=',' read -ra args <<<"${rune}"
        link=${args[0]}
        file=${args[1]}
        if [ -h "$link" ] && ! [ -e "$link" ]; then
            echo -e "\033[31mRemoving broken rune: $(basename "$link")\033[0m"
            if any_match sudo "${args[@]:2}"; then
                sudo rm "$link"
            else
                rm "$link"
            fi
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
        any_match generated "${args[@]:2}" && generated=1
        [ "$ifdir" ] && [ ! -e "$(dirname "$link")" ] && continue
        if [ "$generated" ]; then
            [ ! -e "$link" ] || [ "$link" -ot "$(pwd)/${args[1]}" ]
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
    any_match exe "${@:3}" && exe=1
    [ "$generated" ] && [ "$force" ] &&
        echo -e '\e[33mWarning:\e[0m Forced does nothing when combined with generated'
    local target="$(pwd)/$1"
    local link_name="$2"
    [[ "$generated" ]] && {
        set -x
    }
    if [ ! -h "$2" ] || { [ "$generated" ] && [ "$link_name" -ot "$target" ]; }; then
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
        [ "$exe" ] && [ ! -x "$link_name" ] && chmod -v +x "$link_name"
        echo -en "\033[0m"
    fi
    set +x
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
