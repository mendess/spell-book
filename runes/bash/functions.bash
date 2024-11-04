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
    __run_disown zathura "$1"
}

alarm() {
    if [ $# -lt 1 ]; then
        echo "provide a time string"
        return 1
    fi
    {
        sleep "$1"
        notify-send -u critical "Alarm" "$2" -a "$(basename "$0")"
        mpv --no-video --volume 50 /usr/share/sounds/freedesktop/stereo/alarm*
    } &
    disown
}

degen() {
    python3 -c '
from random import choice
from sys import argv
print("".join((map(lambda x: x.upper() if choice([True, False]) else x.lower(), " ".join(argv[1:])))))
' "$@"
}

gcl() {
    if [[ "$(whoami)" = pmendes ]]; then
        mk_repo_dir() {
            project=$(basename $(dirname "$1") | rev | cut -d: -f1 | rev)
            mkdir -p _$project
            cd _$project
        }
    else
        mk_repo_dir() { :; }
    fi
    case "$1" in
        http://*)
            echo '============================> using http'
            read -p 'press enter to continue anyway' && \
                mk_repo_dir "$1" && \
                git clone "$@"
            ;;
        git@* | https://* | ssh://*)
            mk_repo_dir "$1"
            git clone "$@"
            ;;
        */*)
            mk_repo_dir "$@"
            git clone git@github.com:"$1" "${@:2}"
            ;;
        *)
            gh_name=$(git config --global user.name)
            mk_repo_dir "$gh_name"
            git clone git@github.com:"$gh_name/$1" "${@:2}"
            ;;
    esac
    cd "$(basename "${1%.git}")"
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

xdofast() {
    # shellcheck disable=SC2031
    # shellcheck disable=SC2030
    export DISPLAY=:0
    echo "alias x='xdotool'"
    echo "alias xk='xdotool key'"
    echo "alias xt='xdotool type'"
    alias x='xdotool'
    alias xk='xdotool key'
    alias xt='xdotool type'
}

mpvy() {
    mpv --no-video "ytdl://ytsearch:$*"
}

mpvys() {
    mpvs "ytdl://ytsearch:$*"
}

mpvyv() {
    mpv "ytdl://ytsearch:$*"
}

mpvysv() {
    mpvsv "ytdl://ytsearch:$*"
}

mpv_get() {
    #shellcheck disable=2119
    echo '{ "command": ["get_property", "'"$1"'"] }' |
        socat - "$(m socket)" |
        jq "${2:-.}" "${@:3}"
}

any() {
    find "${1:-.}" -maxdepth 1 | shuf -n 1
}

insist() {
    until eval "$@"; do sleep ${T:-0}; done
}

nest() {
    # example:
    # nest new-dir *

    tmp=..
    [ "$PWD" = / ] && tmp=/tmp
    dir="$tmp/$1"
    echo "Gonna create $1 at $dir and move stuff there"
    read
    mkdir "$dir" || return
    mv "${@:2}" "$dir" || return
    mv "$dir" . || return
}

create-latex-git-ignore() {
    cat <<EOF
*.toc
*.aux
*.log
*.pdf
*.html
*.bbl
*.blg
_minted-presentation/
*.nav
*.out
*.snm
*.vrb
EOF
}

sshp() {
    ssh "$1" '. $HOME/.bash_profile; '"${*:2}"
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

function torrent() {
    pgrep -f transmission-daemon >/dev/null || {
        transmission-daemon --download-dir ~/dl/
        echo -n "waiting for deamon to start"
        sleep 5
        echo -en "\r\e[K"
    }
    case "$1" in
        a | add)
            transmission-remote -a "${@:2}"
            ;;
        d | del)
            local t
            t="$(transmission-remote -l |
                grep -vP '^(\s+ID)|Sum:' |
                fzf --height="$(transmission-remote -l | wc -l)" \
                    --layout=reverse |
                awk '{print $1}' |
                sed 's/\*//g')"
            [[ "$t" ]] || return 0
            transmission-remote -t "$t" --remove
            ;;
        '' | l | list)
            transmission-remote -l
            ;;
        *)
            cat <<EOF
Usage: $0 COMMAND

Commands:
    l | list
        List running torrents
    a | add
        Add a torrent to the list
    d | del
        Remove a torrent
EOF
            ;;
    esac
}

make-gif-of-photos() {
    if [ $# -lt 2 ]; then
        cat <<EOF
Make a cute foto montage

Usage: $0 image1 image2 output.gif
EOF
    fi
    convert -limit memory 64 -delay 50 -loop 0 -dispose previous "$@"
}

sshfs() {
    if [[ ! -d "$2" ]]; then
        mkdir -p "$2" || return
    fi
    command sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 "$@"
}

bak() {
    if [[ "$1" = *bak ]]; then
        cp "$1" "${1%.bak}"
    else
        cp "$1" "$1.bak"
    fi
}

function gb {
    if [[ "$1" ]]; then
        git branch "$@"
    else
        git --no-pager branch -vv |
            sed -E 's/ \[[^]]*origin[^]]*\]//' |
            cut -b-"$(tput cols)" |
            GREP_COLORS="mt=1;32" grep --color=always -E '^\* [^/ ]+|' |
            GREP_COLORS="mt=32"   grep --color=always -E '^\* [^ ]+|' |
            GREP_COLORS="mt=33"   grep --color=always -E ' [a-f0-9]{8,10} |' |
            GREP_COLORS="mt=34"   grep --color=always -E '^  [^/]+|'
    fi
}

function wait-for-ci {
    gh run watch
    notify-send "${1:-CI DONE} ${*:2}" -u critical
}

base64url::encode() {
    base64 -w0 | tr '+/' '-_' | tr -d '='
}

base64url::decode() {
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
