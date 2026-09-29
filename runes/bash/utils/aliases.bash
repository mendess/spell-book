#!/bin/bash

alias py="python3"
alias pyenv="source .env/bin/activate"
alias :q=exit
alias :r="source ~/.bashrc"

s() {
    if hash sxiv &>/dev/null; then
        sxiv "$@"
    elif hash nsxiv &>/dev/null; then
        nsxiv "$@"
    else
        echo "'s' command not found"
        return 1
    fi
}

alias sudo='sudo '
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias sctl='systemctl'

hash neofetch &>/dev/null ||
    alias neofetch="curl -L --silent https://mendess.xyz/files/neofetch | bash"

alias ytdl='yt-dlp'
alias ikhal='ikhal; clear'
alias uuid='cat /proc/sys/kernel/random/uuid'
