#!/bin/bash
#shellcheck disable=2155
# Creates a sym-link for every rune in [runes](runes/). The location of the
# sym-link depends on the rune and is defined in [runes/.db].

## Option docs:
## - sudo: Require sudo to install the dotfiles
## - generated: Dotfile is generated based on host
## - ifdir: Only install if it's directory already exists
## - copy: Copy instead symlinking

verbose="$1"

any-match() {
    local i
    for i in "${@:2}"; do
        [ "$i" = "$1" ] && return
    done
    return 1
}

join-by() {
    local IFS="$1"
    shift
    echo "$*"
}

sudo_host() {
    local h
    for h in tolaria weatherlight mirrodin argentum kaladesh; do
        [ "$(hostname)" = "$h" ] && return 0
    done
    return 1
}

if ! sudo_host; then
    sudo() {
        echo "sudo not available"
    }
fi

if [[ "$SPELLS" ]]; then
    cd "$SPELLS/runes" || exit 1
else
    cd "$(dirname "$0")"/runes || exit 1
fi

rune-wanted() {
    ../.install-profile/allows.sh castRunes "$1" || {
        case "$verbose" in
            -v|--verbose)
                echo "rune $1 skipped"
                ;;
        esac
        false
    }
}

expanded_runes=()
rune_dir=()

expand() {
    local file f
    for file in "$2"/*; do
        f="$(basename "$file")"
        if [ -d "$file" ]; then
            rune_dir+=("$(join-by ',' "$1" "${@:2}")")
            expand "$1/$f" "$2/$f" "${@:3}"
        else
            expanded_runes+=("$1/$f,$2/$f,$(join-by , "${@:3}")")
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
                echo -e "too many matches: \n$(join-by "\n\t" "${a[@]}")" &&
                break
            path="${a[0]}"
        done
        [[ $path =~ .*\*.* ]] && continue
        link="$path"
    }
    args[0]="$link"
    if [ -d "$file" ]; then
        rune_dir+=("$(join-by ',' "$link" "${args[@]:2}")")
        expand "${args[@]}"
    else
        expanded_runes+=("$(join-by ',' "${args[@]}")")
    fi
done < <(sed '/^#/d' ../runes/.db)

clean-runes() {
    local rune
    for rune in "${expanded_runes[@]}"; do
        local link file args
        IFS=',' read -ra args <<<"${rune}"
        link=${args[0]}
        file=${args[1]}
        if [ -h "$link" ] && ! [ -e "$link" ]; then
            echo -e "\033[31mRemoving broken rune: $(basename "$link")\033[0m"
            if any-match sudo "${args[@]:2}"; then
                sudo rm "$link"
            else
                rm "$link"
            fi
        fi
    done
    while read -r d ; do
        local dir args
        IFS=',' read -ra args <<<"$d"
        dir=${args[0]}
        [ -e "$dir" ] || continue
        args=("${args[@]:1}")
        while read -r link_to_rm; do
            echo -e "\033[31mRemoving broken rune: $(basename "$link_to_rm")\033[0m"
            if any-match sudo "${args[@]}"; then
                sudo rm "$link_to_rm"
            else
                rm "$link_to_rm"
            fi
        done < <(find -L "$dir" -type l)
    done < <(printf "%s\n" "${rune_dir[@]}" | sort -u)
    return 1
}

new-runes() {
    local rune
    for rune in "${expanded_runes[@]}"; do
        local args link
        IFS=',' read -r -a args <<<"${rune}"
        link="${args[0]}"
        if ! rune-wanted "${args[1]}" >/dev/stderr; then
            continue
        fi
        unset ifdir generated copy
        any-match sudo "${args[@]:2}" && ! sudo_host && continue
        any-match ifdir "${args[@]:2}" && ifdir=1
        any-match generated "${args[@]:2}" && generated=1
        any-match copy "${args[@]:2}" && copy=1

        [ "$ifdir" ] && [ ! -e "$(dirname "$link")" ] && continue

        if [ "$generated" ]; then
            [ ! -e "$link" ] || [ "$link" -ot "$(pwd)/${args[1]}" ]
        elif [ "$copy" ]; then
            ! cmp -s "$link" "$(pwd)/${args[1]}"
        else
            [ ! -h "$link" ]
        fi && echo "$rune"
    done
}

link-rune() {
    local generated force exe cmd copy
    any-match generated "${@:3}" && generated=1
    any-match force "${@:3}" && force=1
    any-match exe "${@:3}" && exe=1
    any-match copy "${@:3}" && copy=1

    local target="$(pwd)/$1"
    local link_name="$2"

    cmd=()
    if [[ "$generated" ]]; then
        [[ "$force" ]] &&
            echo -e "\e[33mWarning:\e[0m 'forced' does nothing when combined with 'generated'"
        [[ "$link_name" -ot "$target" ]] &&
            cmd=(python3 "$(pwd)/../generate_config.py" "$target" "$link_name")
    elif [[ "$copy" ]]; then
        if [[ "$force" ]] || ! cmp -s "$target" "$link_name"; then
            cmd=(cp --verbose "$target" "$link_name")
        fi
    elif [[ ! -L "$link_name" ]] || [[ "$(readlink -f "$link_name")" != "$(readlink -f "$target")" ]]; then
        cmd=(ln --symbolic --verbose)
        [[ "$force" ]] && cmd+=(--force)
        cmd+=("$target" "$link_name")
    fi
    if [[ "${#cmd[@]}" -gt 0 ]]; then
        if any-match sudo "${@:3}"; then
            echo -en "\033[31mHard \033[35mCasting "
            sudo "${cmd[@]}"
        else
            echo -en "\033[35mCasting "
            "${cmd[@]}"
        fi
        [ "$exe" ] &&
            [ ! -x "$link_name" ] &&
            echo "and chmod +x $link_name" &&
            chmod -v +x "$link_name"
        echo -en "\033[0m"
    fi
}

make-dir-if-absent() {
    if [ ! -e "$1" ]; then
        any-match ifdir "${@:2}" && return 1
        echo -e "\033[31mMissing \033[36m$1\033[31m directory, creating....\033[0m"
        mkdir --parent "$1"
    fi
    return 0
}

clean-runes
mapfile -t runes < <(new-runes)
if [[ "${#runes[@]}" -eq 0 ]]; then
    exit 0
fi

echo -e "\033[33mCasting Runes...\033[0m"

for rune in "${runes[@]}"; do
    IFS=',' read -r -a args <<<"${rune}"
    link="${args[0]}"
    file="${args[1]}"
    if make-dir-if-absent "$(dirname "$link")" "${args[@]:2}"; then
        link-rune "$file" "$link" "${args[@]:2}"
    fi
done
echo -e "\033[33mDone!\033[0m"
