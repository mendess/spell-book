#!/bin/bash

__run_disown() { # $1 program, $2 file
    local filesize=10
    local file="$2"
    if [[ ! "$file" ]] && [[ -f ~/.cache/my_recents/"$1" ]]; then
        file=$(sed -e "s|$HOME|~|" ~/.cache/my_recents/"$1" | dmenu -i -l "$filesize")
        [[ "$file" ]] || return
        file=$HOME${file//\~//}
    fi
    file="$(realpath "$file")"
    "$1" "$file" &>/dev/null &
    disown
    [[ -e "$file" ]] && {
        mkdir -p ~/.cache/my_recents
        touch ~/.cache/my_recents/"$1"
        local temp
        temp=$(mktemp)
        echo "$file" |
            cat - ~/.cache/my_recents/"$1" |
            awk '!seen[$0]++' |
            head -$filesize >|"$temp"
        mv "$temp" ~/.cache/my_recents/"$1"
    }
}

pdf() {
    __run_disown zathura "$1" && exit
}

za() {
    for p in "$@"; do
        __run_disown zathura "$p"
    done
}

alarm() {
    if [ $# -lt 1 ]; then
        echo "provide a time string"
        return 1
    fi
    (
        set -e
        sleep "$1"
        shift
        notify-send -u critical "Alarm" "$*" -a "$(basename "$0")"
        mpv --no-video --volume=50 /usr/share/sounds/freedesktop/stereo/alarm*
    ) &
    disown
}

nospace() {
    for file in *; do
        grep ' ' <<<"$file" || continue
        new_name=$(sed -r "s/['&,()!]//g;s/ ([-_]) /\\1/g;s/ /-/g;s/_+/-/g" <<<"$file")
        if [ -e "$new_name" ]; then
            echo "can't rename $file to $new_name. A file with that name already exists"
        else
            mv -vn "$file" "$new_name"
        fi
    done
}

any() {
    if [[ "$#" -eq 1 ]]; then
        find_arg=(.)
    else
        find_arg=("$@")
    fi
    find "${find_arg[@]}" -maxdepth 1 | shuf -n 1
}

insist() {
    if [[ "$1" ]]; then
        proc="$*"
    else
        proc=!!
    fi
    until eval "$proc"; do sleep "${T:-0}"; done
}

nest() {
    # example:
    # nest new-dir *

    tmp=..
    [ "$PWD" = / ] && tmp=/tmp
    dir="$tmp/$1"
    echo "Gonna create $1 at $dir and move stuff there"
    read -r
    mkdir "$dir" || return
    mv "${@:2}" "$dir" || return
    mv "$dir" . || return
}

3_simple() {
    l1="$1"
    r1="$2"
    l2="$3"
    r2="${4:-x}"
    if [ "$l2" = x ]; then
        echo "($r2 * $l1) / $r1" | bc -l
    elif [ "$r2" = x ]; then
        echo "($l2 * $r1) / $l1" | bc -l
    else
        echo "Error needs at least one x"
    fi
}

function which() {
    local w
    w="$(command -V "$1")"
    case "$w" in
        *'is a function'*)
            echo "${w#*$'\n'}"
            ;;
        *'is aliased to'*)
            w="${w#*\`}"
            echo "${w%\'*}"
            ;;
        *)
            echo "${w##* }" | tr -d '()'
            ;;
    esac
}

sshfs() {
    if [[ ! -d "$2" ]]; then
        mkdir -p "$2" || return
    fi
    command sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 "$@"
}

bak() {
    if [[ "$1" = *bak ]]; then
        cp -r "$1" "${1%.bak}"
    else
        cp -r "$1" "$1.bak"
    fi
}

base64::url::encode() {
    base64 -w0 | tr '+/' '-_' | tr -d '='
}

base64::url::decode() {
    awk '{
        if (length($0) % 4 == 3)
            print $0"=";
        else if (length($0) % 4 == 2)
            print $0"==";
        else print $0;
    }' |
        tr -- '-_' '+/' |
        base64 -d
}

md5dir() {
    tar c "$1" | md5sum
}

alert() {
    local icon
    #shellcheck disable=2181
    if [ "$?" -eq 0 ]; then
        icon=/usr/share/icons/Adwaita/48x48/emblems/emblem-ok-symbolic.symbolic.png
    else
        icon=/usr/share/icons/Adwaita/48x48/actions/edit-delete-symbolic.symbolic.png
    fi
    local body
    body=$(history 1 | sed 's/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//')
    notify-send -i "$icon" "$body"
}

nmcli::monitor() {
    nmcli -c yes monitor | while read -r line; do
        echo -e "\e[0m[$(date)] $line"
    done
}
