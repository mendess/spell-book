#!/bin/bash

#shellcheck disable=SC2139
# LS
if hash exa &>/dev/null; then
    alias exa='exa -g'
    alias ls='exa'
    alias tree='exa -T'
    alias li='exa --git --git-ignore'
    alias lli='exa -l --git --git-ignore'
    alias lg='exa -laah --git'
else
    alias ls='ls --color=auto'
fi
alias la='ls -la'
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
alias gs=gst # fuck ghost script
alias gbr='gb -r'
alias gdd='git difftool --tool=vimdiff'
alias g=git
alias ga='git add'
alias gaa='git add --all'
alias gau='git add --update'
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
alias gpt='git push; git push origin --tags'
alias gpf='git push --force-with-lease'
alias gpft='git push --force; git push origin --tags'
alias gst='git status'
alias gcm='git checkout master || git checkout main'
alias gcd='git checkout develop || git checkout dev'
__guri() {
    echo "https://github.com/$(git remote get-url --push origin | sed -r 's|.*[:/](.*)/(.*)(.git)?|\1/\2|g')"
}
alias gfi='xdg-open "$(__guri)"'
alias gpr='xdg-open "$(__guri)/pull/new/$(git symbolic-ref --short HEAD)"'
alias gpsup='git push --set-upstream origin $(git symbolic-ref --short HEAD)'
if hash gh &>/dev/null; then
    alias gpsupr='gpsup ; gh pr create -a @me'
else
    alias gpsupr='git push --set-upstream origin $(git symbolic-ref --short HEAD) && xdg-open "$(__guri)/pull/new/$(git symbolic-ref --short HEAD)"'
fi
# CARGO
alias cr='cargo run'
alias cb='cargo build'
alias crr='cargo run --release'
alias cbr='cargo build --release'
alias cch='cargo check'
alias ct='cargo test'

alias cnr='cargo +nightly run'
alias cnb='cargo +nightly build'
alias cnrr='cargo +nightly run --release'
alias cnbr='cargo +nightly build --release'
alias cnch='cargo +nightly check'
alias cnt='cargo +nightly test'

alias ca=cargo
alias cn='cargo +nightly'

alias bashrc="vim $SPELLS/runes/bash"
alias vimrc="vim ~/.config/nvim/init.vim"
alias viminstall='vim +:PlugClean +:PlugInstall +:PlugUpdate +:PlugUpgrade'
alias py="python3"
alias c="clear"
alias pyenv="source .env/bin/activate"
alias makeclean="find . -maxdepth 1 -type f -executable -delete"
alias :q=exit
hash nvim &>/dev/null && alias vim=nvim
alias bc="bc -lq"
command -V bat &>/dev/null &&
    alias bat='bat --theme=base16 -p' &&
    alias cat=bat
alias :r="source ~/.bashrc"
alias db="dropbox-cli"
alias mpvs='mpv --no-video --input-ipc-server=$(m socket new)'
alias mpvsv='mpv --input-ipc-server=$(m socket new)'
alias s='sxiv'
if command -v evcxr &>/dev/null; then
    alias rs='evcxr'
else
    alias rs="echo 'evcxr' command not found. Install it with 'cargo install evcxr_repl'"
fi
alias sudo='sudo '
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias whoshome='cd ~/Projects/whoshome/; pyenv; py main.py; deactivate; cd - &>/dev/null'
alias screenoff='DISPLAY=:0 xset dpms force off'
alias spotify="LD_PRELOAD=$HOME/.local/bin/spotify-adblock.so spotify"
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias tmux="tmux -2 -f $XDG_CONFIG_HOME/tmux/tmux.conf"
alias sctl='systemctl'
alias install-occult='ssh mirrodin "cat ~/disk0/occult-book/install" | sh'
alias oldvim='/bin/vim'
alias matrixmap='sudo nmap -v -sS -O'
alias alert='notify-send -i "$([ $? = 0 ] && echo "/usr/share/icons/Adwaita/48x48/emblems/emblem-ok-symbolic.symbolic.png" || echo "/usr/share/icons/Adwaita/48x48/actions/edit-delete-symbolic.symbolic.png")" "$(history 1 | sed '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
#shellcheck disable=2142
alias fix_divinity="cd $HOME/.steam/steam/steamapps/common/Divinity\ Original\ Sin\ 2/ && mv ./bin ./bin.bak && ln -s DefEd/bin bin && cd bin && mv ./SupportTool.exe ./SupportTool.bak && ln -s EoCApp.exe SupportTool.exe"
command -v neofetch &>/dev/null ||
    alias neofetch="curl --silent mendess.xyz/file/neofetch | bash"
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'
alias ytdl='youtube-dl'
alias ard='arduino-cli'
alias hc=herbstclient
alias ikhal='ikhal; clear'
alias love='ssh berrygood -t tmux a -t chat'
alias rustfmttoml='cp -v $SPELLS/runes/rustfmt.toml .'
alias raycaster='awk -f <(curl https://raw.githubusercontent.com/TheMozg/awk-raycaster/master/awkaster.awk)'
alias queres='echo queres'


# Cleanup
command -v weechat &>/dev/null && alias weechat='weechat -d $XDG_CONFIG_HOME/weechat'
command -v calcurse &>/dev/null && alias calcurse='calcurse -C "$XDG_CONFIG_HOME"/calcurse -D "$XDG_DATA_HOME"/calcurse'
command -v julia &>/dev/null && alias julia='HOME=$XDG_CACHE_HOME julia'

alias sunrisemor='ssh berrygood bulb/flow.py sunrise'
