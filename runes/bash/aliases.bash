#!/bin/bash

#shellcheck disable=SC2139
# LS
if hash exa &>/dev/null
then
    alias exa='exa -g'
    alias ls='exa'
    alias tree='exa -T'
    alias li='exa --git --git-ignore'
    alias lli='exa -l --git --git-ignore'
    alias la='exa -la'
    alias lg='exa -laah --git'
fi
alias l='ls -lha'
alias ll='ls -lh'
alias cl="clear; ls -lh"
alias clg="clear; ls -lh --git"
# DOCKER
alias doc='docker'
alias dor='docker run'
alias dob='docker build'
alias dos='docker stop'
alias dop='yes | docker container prune'
## GIT
alias gb='g --no-pager branch -vv'
alias gdd='git difftool --tool=vimdiff'
alias g=git
alias ga='git add'
alias gaa='git add --all'
alias gbD='git branch -D'
alias gbl='git blame -b -w'
alias gc='git commit -v'
alias glog='git log --pretty=format:'\''%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s'\'' --date=short --graph'
alias glogn='git --no-pager log --oneline --decorate --graph'
alias 'gc!'='git commit -v --amend'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpsup='git push --set-upstream origin $(git symbolic-ref --short HEAD)'
alias gst='git status'
alias gcm='git checkout master'
# CARGO
alias cr='cargo run'
alias cb='cargo build'
alias crr='cargo run --release'
alias cbr='cargo build --release'
alias cch='cargo check'
alias cnr='cargo +nightly run'
alias cnb='cargo +nightly build'
alias cnrr='cargo +nightly run --release'
alias cnbr='cargo +nightly build --release'
alias cnch='cargo +nightly check'

alias bashrc="vim $SPELLS/runes/bash"
alias vimrc="vim ~/.config/nvim/init.vim"
alias py="python3"
alias c="clear"
alias pyenv="source .env/bin/activate"
alias makeclean="find . -maxdepth 1 -type f -executable -delete"
alias :q=exit
alias vim=nvim
alias bc="bc -l"
alias :r="source ~/.bashrc"
alias i3config="vim ~/.config/i3/config"
alias i3statusconfig="vim ~/.config/i3status/config"
alias db="dropbox-cli"
alias mpvs='mpv --no-video --input-ipc-server=$(mpvsocket new)'
alias mpvsv='mpv --input-ipc-server=$(mpvsocket new)'
alias s='sxiv'
alias notes='mn'
alias rs='evcxr'
alias sudo='sudo '
alias ..='cd ..'
alias ...=../..
alias ....=../../..
alias .....=../../../..
alias ......=../../../../..
alias whoshome='cd ~/Projects/whoshome/; pyenv; py main.py; deactivate; cd - &>/dev/null'
alias screenoff='DISPLAY=:0 xset dpms force off'
alias spotify="LD_PRELOAD=$HOME/.local/bin/spotify-adblock.so spotify"
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias tmux='tmux -2'
alias sctl='systemctl'
alias install-occult='ssh mirrodin "cat ~/disk0/occult-book/install" | sh'
