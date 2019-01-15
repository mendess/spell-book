function allgrep {
    # -I ignore binary files; -H with file name; -n with line numbers; -e PATERNS
    grep -IHn -e "$1" $(find . -type f | grep -v '.git') 2>/dev/null
}

function allsed {
    if [[ "$#" -lt 2 ]];
    then
        echo "Usage: $0 <find> <replace>"
    else
        allgrep "$1" | cut -d':' -f1 | sort | uniq | xargs sed -e "s/$1/$2/g" -i
    fi
}

function benchmark {
    for i in {1..5}
    do
        echo -e "\033[34mRun #$i: Starting\033[0m"
        if time "$@" > /dev/null
        then
            echo -e "\033[32mRun #$i: Done\033[0m"
        else
            echo -e "\033[31mRun #$i: Failed\033[0m"
            break
        fi
        [ $i = "5" ] && break

        for t in {15..0}
        do
            echo -en "$t"
            sleep 1s
            [[ "$t" -ge 10 ]] && echo -en "\b"
            echo -en "\b"
        done
    done
}

function make {
    if [ -e Makefile ] || [ -e makefile ]
    then
        bash -c "make $*"
    else
        for i in *.c;
        do
            file=${i//\.c/}
            bash -c "make $file"
        done
    fi
}

function ex {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *)           echo "$1 cannot be extracted via ex()" ;;
    esac
  else
    echo "$1 is not a valid file"
  fi
}

function __append_to_recents { # $1 line, $2 recents file
    mkdir -p ~/.cache/my_recents
    touch ~/.cache/my_recents/"$2"
    echo "$1" | cat - ~/.cache/my_recents/"$2" | awk '!seen[$0]++' | head -10 > temp && mv temp ~/.cache/my_recents/"$2"
}

function __run_disown {
    local file="$2"
    if [ "$file" = "" ] && [ -f ~/.cache/my_recents/"$1" ]; then
        file=$(sed -e 's/\/home\/mendess/~/' ~/.cache/my_recents/"$1" | dmenu -i -l "$(wc -l ~/.cache/my_recents/"$1")")
        [ "$file" = "" ] && return 1
        file=$HOME${file//\~//}
    fi
    "$1" "$(readlink -f "$file")" &> /dev/null &
    disown
    __append_to_recents "$(readlink -f "$file")" "$1"
}

function pdf {
    __run_disown zathura "$1" && exit
}

function za {
    __run_disown zathura "$1"
}

function allClips {
    echo "primary  : $(xclip -selection primary   -o 2>/dev/null)"
    echo "secondary: $(xclip -selection secondary -o 2>/dev/null)"
    echo "clipboard: $(xclip -selection clipboard -o 2>/dev/null)"
}

alias zshrc="vim ~/.oh-my-zsh/custom/aliases.zsh"
alias open="xdg-open"
alias clip="xclip -sel clip"
alias vimrc="vim ~/.config/nvim/init.vim"
alias py="python3"
alias c="clear"
alias seppuku="toilet -f smblock -F metal:border Shuting Down... && sleep 1; shutdown +0 &> /dev/null"
alias pyenv="source .env/bin/activate"
alias makeclean="find . -maxdepth 1 -type f -executable -delete"
alias makeinstall='for i in *.c; make $(echo $i | sed -e "s/\.c//g")'
alias :q="exit"
alias countLines="echo 'Number of lines '\$(echo \$(for i in \$(find . | grep -v '\.git/'); do wc -l \$i 2> /dev/null | awk '{print \$1}'; done) | sed 's/\\ /+/g' | bc)"
alias vim="nvim"
alias gps='git push --set-upstream origin $(git symbolic-ref --short HEAD)'
alias dex="~/gitProjects/unix_dex/target/debug/unix_dex"
alias bc="bc -l"
alias ghci="stack ghci"
alias :r="source ~/.zshrc"
alias cl="clear; ls -lah"
alias pls="sudo \$(history -1 | awk '{\$1=\"\"; print \$0 }')"
alias vim.='vim .'
alias i3config="vim ~/.config/i3/config"
alias i3statusconfig="vim ~/.config/i3status/config"
alias db="dropbox-cli"
alias dbf="dropbox-cli filestatus"
alias t="/usr/bin/time -p"
alias synthwave='mpv --no-video https://www.youtube.com/playlist\?list\=UUwoTj-pZgZZ8DInOXSSLMmA'
alias gamend="git commit --amend"
alias e="exit"
alias autoBuildRust="find . | grep '\.rs' | entr -c cargo build"
alias mpvs='mpv --no-video --input-ipc-server=/tmp/mpvsocket'
alias mpvsv='mpv --input-ipc-server=/tmp/mpvsocket'
alias record='ffmpeg -video_size 1920x1080 -framerate 60 -f x11grab -i :0.0+0,0 "output-$(date +"%d_%m_%Y_%H_%M").mp4"'
