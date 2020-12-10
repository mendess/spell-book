#!/bin/bash

make() {
    if [[ -e Makefile ]] || [[ -e makefile ]] || [[ "$1" ]]; then
        command make -j"$(nproc || echo 4)" "$@"
    else
        for i in *.c; do
            file=${i//\.c/}
            command make "$file"
        done
    fi
}

ex() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.bz2) bunzip2 -v "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *.xz) xz -d "$1" ;;
            *) echo "$1 cannot be extracted via ex()" ;;
        esac
    else
        echo "$1 is not a valid file"
    fi
}

__append_to_recents() { # $1 line, $2 recents file
    mkdir -p ~/.cache/my_recents
    touch ~/.cache/my_recents/"$2"
    echo "$1" | cat - ~/.cache/my_recents/"$2" | awk '!seen[$0]++' | head -10 >temp && mv temp ~/.cache/my_recents/"$2"
}

__run_disown() {
    local file="$2"
    if [ "$file" = "" ] && [ -f ~/.cache/my_recents/"$1" ]; then
        file=$(sed -e 's/\/home\/mendess/~/' ~/.cache/my_recents/"$1" | dmenu -i -l "$(wc -l ~/.cache/my_recents/"$1")")
        [ "$file" = "" ] && return 1
        file=$HOME${file//\~//}
    fi
    file="$(realpath "$file")"
    "$1" "$file" &>/dev/null &
    disown
    [ -e "$file" ] && __append_to_recents "$file" "$1"
}

pdf() {
    __run_disown zathura "$1" && exit
}

za() {
    __run_disown zathura "$1"
}

alarm() {
    if [ $# -lt 1 ]; then
        echo provide a time string
        return 1
    fi
    {
        link="https://www.youtube.com/watch?v=4iC-7aJ6LDY"
        sleep "$1"
        mpv --no-video "$link" --input-ipc-server=/tmp/mpvalarm &
        notify-send -u critical "Alarm" "$2" -a "$(basename "$0")"
    } &
    disown
}

matrix() {
    echo -e "\e[1;40m"
    clear
    while :; do
        echo $LINES $COLUMNS $((RANDOM % COLUMNS)) $((RANDOM % 72))
        sleep 0.05
    done |
        awk '{ letters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"; c=$4; letter=substr(letters,c,1);a[$3]=0;for (x in a) {o=a[x];a[x]=a[x]+1; printf "\033[%s;%sH\033[2;32m%s",o,x,letter; printf "\033[%s;%sH\033[1;37m%s\033[0;0H",a[x],x,letter;if (a[x] >= $1) { a[x]=0; } }}'
}

loop() {
    n=""
    while ! [ "$n" = "n" ]; do
        "$@"
        read -r n
    done
}

clearswap() {
    local drive
    drive="$(lsblk -i | grep SWAP | awk '{print $1}' | sed -r 's#[|`]-#/dev/#')"
    sudo swapoff "$drive"
    sudo swapon "$drive"
}

vimbd() {
    vimb "$1" &
    disown
    exit
}

svim() {(
    cd "$SPELLS" || return 1
    if [ -n "$1" ]; then
        "$EDITOR" "$1"
    else
        local DIR
        DIR="$(find . -type f |
            grep -vP '\.git|library' |
            sed 's|^./||g' |
            fzf)"
        [ -n "$DIR" ] && "$EDITOR" "$DIR"
    fi
)}

k() {
    if lsusb | grep -E 'Mechanical|Keyboard|Kingston' &>/dev/null; then
        setxkbmap us -option caps:escape -option altwin:menu_win
        xmodmap -e 'keycode  21 = plus equal plus equal'
    else
        setxkbmap pt -option caps:escape -option altwin:menu_win
    fi
}

advent-of-code() {
    if [[ "$1" != day* ]]; then
        echo "bad input: '$1'"
        return 1
    fi
    cargo new "$1" || return 1
    cd "$1" || return 1
    echo '
[[bin]]
name = "one"
path = "src/one.rs"

[[bin]]
name = "two"
path = "src/two.rs"' >>Cargo.toml
    cp src/main.rs src/one.rs
    cp src/main.rs src/two.rs
    rm src/main.rs
}

degen() {
    python3 -c '
from random import choice
from sys import argv
print("".join((map(lambda x: x.upper() if choice([True, False]) else x.lower(), " ".join(argv[1:])))))
' "$@"
}

record() {
    if [ "$1" = right ]; then
        i=1920
    else
        i=0
    fi
    ffmpeg \
        -video_size 1920x1080 \
        -framerate 30 \
        -f x11grab \
        -i :0.0+$i,0 \
        -vcodec nvenc \
        "output-$(date +"%d_%m_%Y_%H_%M").mp4"
}

share() {(
    set -e
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -u | --unlisted)
                unlisted=1
                ;;
            *)
                if [[ "$FILE" ]]; then
                    filename="$1"
                else
                    FILE="$1"
                fi
                ;;
        esac
        shift
    done
    [ "$filename" ] || filename="$(basename "$FILE")"
    if [ -d "$FILE" ]; then
        zip -r "/tmp/$filename.zip" "$FILE"
        FILE="/tmp/$filename.zip"
        filename="$filename.zip"
    fi
    [[ "$unlisted" ]] && filename="unlisted/$filename"
    scp "$FILE" "mirrodin:~/disk0/Mirrodin/share/$filename"
    url="http://mendess.xyz/file/$filename"
    if command -v termux-clipboard-set &>/dev/null; then
        echo -n "$url" | termux-clipboard-set
    else
        echo -n "$url" | xclip -sel clip
    fi
    echo "$url"
)}

connect() {
    if [ $# -lt 2 ]; then
        echo "Usage: $0 ssid password"
        return
    fi
    nmcli device wifi connect "$1" password "$2"
}

gcl() {
    case "$1" in
        http://*)
            echo '============================> using http'
            git clone "$@"
            ;;
        git@* | https://*)
            git clone "$@"
            ;;
        */*)
            git clone git@github.com:"$1" "${@:2}"
            ;;
        *)
            git clone git@github.com:"$(git config --global user.name)"/"$1" "${@:2}"
            ;;
    esac
}

nospace() {
    for file in *; do
        grep ' ' <(echo "$file") || continue
        mv -vn "$file" "$(echo "$file" | sed -r "s/['&,()!]//g;s/ ([-_]) /\\1/g;s/ /_/g;s/_+/_/g")"
    done
}

xdofast() {
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
        jq "${2:-.}"
}

any() {
    find "${1:-.}" -maxdepth 1 | shuf -n 1
}

insist() {
    until eval "$@"; do :; done
}

nest() {
    tmp=..
    [ "$PWD" = / ] && tmp=/tmp
    dir="$tmp/$1"
    echo "Gonna create $1 at $dir and move stuff there"
    mkdir "$dir" || return
    mv "${@:2}" "$dir" || return
    mv "$dir" . || return
}

lyrics() {
    curl -s --get "https://makeitpersonal.co/lyrics" \
        --data-urlencode "title='${*:2}'" \
        --data-urlencode "artist=$1"
}

fcd() {
    local dir
    for i in {0..64}; do
        printf "depth: %d" $i
        dir="$(find -L . -maxdepth "$i" -type d ! -path './.*' |
            grep -i "$*" |
            head -1)"
        printf "\r\e[K"
        if [ -n "$dir" ]; then
            cd "$dir" || continue
            break
        fi
    done
}

latex_ignore() {
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

function songs() {
    grep -P '.+\t.+\t[0-9]+\t.*'"$1" "$PLAYLIST" |
        awk -F'\t' '{print $2" :: "$1}'
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
    if [[ "$1" = gaja ]]; then
        echo /matilde/oliveira/pizarro/bravo
        return
    fi
    local w
    w="$(command -V "$1")"
    case "$w" in
        *'is a function'*)
            echo "$w" | tail -n +2
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

t() {
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
                awk '{print $1}')"
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
    esac
}

mvim() {
    nvim scp://mirrodin/"$1"
}

google_fotos() {
    convert -limit memory 64 -delay 50 -loop 0 -dispose previous "$@"
}

rga-fzf() {
        RG_PREFIX="rga --files-with-matches"
        local file
        file="$(
                FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
                        fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
                                --phony -q "$1" \
                                --bind "change:reload:$RG_PREFIX {q}" \
                                --preview-window="70%:wrap"
        )" &&
        echo "opening $file" &&
        xdg-open "$file"
}

vim() {
    set +e
    if [[ -d "$1" ]]; then
        cd "$1"
        command nvim .
    elif [[ "$1" ]]; then
    	command nvim "$1"
    else
        command nvim
    fi
}
