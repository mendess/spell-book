#!/bin/bash

#shellcheck disable=SC2139
# COREUTILS
## ls
if hash eza &>/dev/null; then
    ls_bin=eza
elif hash exa &>/dev/null; then
    ls_bin=exa
else
    ls_bin=ls
fi

if hash exa &>/dev/null || hash eza &>/dev/null; then
    alias ls="$ls_bin -g"

    alias tree="$ls_bin -T"
else
    alias ls="$ls_bin --color=auto"
fi
alias la='ls -la'
alias l='ls -lha'
alias cl="clear; ls -lh"

unset ls_bin

## df
if hash duf &>/dev/null; then
    alias df=duf
fi

# du
if hash dust &>/dev/null; then
    alias du=dust
fi

## GIT
alias gs=gst # fuck ghost script
alias gdd='git difftool --tool=vimdiff'
g() {
    if [[ $# -eq 0 ]]; then
        if [ -t 1 ]; then
            git status --short --branch
        else
            git status --short --porcelain --untracked-files=no | awk '{print $2}'
        fi
    else
        git "$@"
    fi

}
alias ga='git add'
alias gaa='git add --all'
alias gau='git add --update'
alias gbD='git branch -D'
alias gbpurge='git fetch --all -p; git branch -vv | grep ": gone]" | awk "{ print \$1 }" | xargs -n 1 --no-run-if-empty git branch -D'
gc() {
    path="$PWD"
    while [[ ! -e "$path/.ccommits" ]] && [[ -e "$path/.git" ]]; do
        echo "$path failed"
        path=$(dirname "$path")
        # get git to print the error message about not being in a repo
        [[ "$path" = / ]] && git commit "$@" && return
    done
    if [[ -e "$path/.pre-commit-checks" ]]; then
        while IFS="\n" read -r check; do
            echo "did you $check?"
            read </dev/tty
        done < "$path/.pre-commit-checks"
    fi
    if [[ ! -e "$path/.ccommits" ]]; then
        git commit "$@"
        return
    fi

    types="fix
feat
build
chore
ci
docs
style
refactor
perf
test"
    commit=$(fzf --prompt 'type ' --print-query <<<"$types" | tail -1)

    read -rp "scope? (leave empty to skip) " scope
    [[ "$scope" ]] && commit="$commit($scope)"

    read -rp 'breaking change? [y/N] ' breaking
    if [[ "$breaking" =~ y|Y ]]; then
        commit="$commit!"
        breaking_footer="BREAKING CHANGE:"
    fi
    args=()
    msg=()
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -m)
                shift
                msg+=("$1")
                ;;
            -m*)
                msg+=("${1:2}")
                ;;
            --message=*)
                msg+=("${1#*=}")
                ;;
            -c*|-C*|-F*)
                found_incompatible_opt=1
                ;;
            *)
                args+=("$1")
                ;;
        esac
        shift
    done
    if [[ "$found_incompatible_opt" ]]; then
        if [[ "${#msg}" -gt 0 ]]; then
            git commit -m -c HEAD^
        else
            git commit "${args[@]}"
        fi
    else
        m="$(printf "%s\n\n" "${msg[@]}")"
        [[ "$breaking_footer" ]] && m="$m"$'\n\n'"$breaking_footer"
        git commit -m "$commit: $m" -e "${args[@]}"
    fi
}
alias 'gc!'='git commit -v --amend'
alias gcwip='git commit -v -mWIP'
alias glog="git log --pretty=format:'%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s' --date=short --graph"
alias glogn='git --no-pager log --oneline --decorate --graph'
function gco() {
    if [ "$#" -eq 0 ]; then
        mapfile -t target < <(
            {
                git branch --format='%(refname:short)' | awk '{print "[B] " $0}'
                git status --porcelain | awk '$1 ~ /M/ { print "[F] " $2 }'
            } | fzf --no-sort | sed -E 's/\[(B|F)\] //'
        )
        git checkout "${target[@]}"
    else
        git checkout "$@"
    fi
}
alias gd='git diff'
alias gf='git fetch'
alias gl='git pull'
gp() {
    if [ $(git log --format=format:%ae | sort -u | wc -l) -gt 1 ]; then
        b=$(git branch)
        case "$b" in
            main|master|dev|develop)
                read -p "You are in '$b', are you sure you want to push? [n/Y] "
                [[ "$REPLY" =~ Y|y ]] || return 0
        esac
    fi
    git push "$@"
}
alias gpt='gp && gp origin --tags'
alias gpf='gp --force-with-lease'
alias gpft='gp --force-with-lease && gp origin --tags'
function gdt() {
    g tag -d "$1" && git push origin --delete "$1"
}
alias gst='git status'
function gcm() {
    case "$(git branch --format='%(refname:short)')" in
        *develop*) git switch develop ;;
        *dev*) git switch dev ;;
        *main*) git switch main ;;
        *master*) git switch master ;;
    esac
}
alias gcmm='git checkout main || git checkout master'
__guri() {
    echo "https://github.com/$(git remote get-url --push origin | sed -r 's|.*[:/](.*)/(.*)(.git)?|\1/\2|g')"
}
alias gfi='xdg-open "$(__guri)"'
alias gpr='xdg-open "$(__guri)/pull/new/$(git symbolic-ref --short HEAD)"'
alias gpsup='gp --set-upstream origin $(git symbolic-ref --short HEAD)'
if hash gh &>/dev/null; then
    alias gpsupr='gpsup ; gh pr create -a @me'
else
    alias gpsupr='gpsup && gpr'
fi
alias gsw='git switch'
alias gsw-='git switch -'
# CARGO
alias c=cargo
alias cr='cargo run'
alias cb='cargo build'
alias crr='cargo run --release'
alias cbr='cargo build --release'
alias cch='cargo clippy'
if hash cargo-nextest &>/dev/null; then
    alias ct='cargo nextest run'
else
    alias ct='cargo test'
fi
alias cdoc='BROWSER=vimb cargo doc --open'

alias cn='cargo +nightly'
alias cnr='cargo +nightly run'
alias cnb='cargo +nightly build'
alias cnrr='cargo +nightly run --release'
alias cnbr='cargo +nightly build --release'
alias cnch='cargo +nightly check'
alias cnt='cargo +nightly test'

alias vims='vim +source Session.vim'
alias viminstall="vim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'; echo"
alias py="python3"
alias pyenv="source .env/bin/activate"
alias :q=exit
hash nvim &>/dev/null && alias vim=nvim
alias bc="bc -lq"
command -V bat &>/dev/null &&
    alias bat='bat --theme=base16' &&
    alias cat='bat -p'
alias :r="source ~/.bashrc"
alias mpvs='mpv --no-video --input-ipc-server=$(m socket new)'
alias mpvsv='mpv --input-ipc-server=$(m socket new)'
if command -v sxiv &>/dev/null; then
    alias s=sxiv
elif command -v nsxiv &>/dev/null; then
    alias s=nsxiv
fi
if command -v evcxr &>/dev/null; then
    alias rs='evcxr --edit-mode vi'
else
    alias rs="echo 'evcxr' command not found. Install it with 'cargo install evcxr_repl'"
fi
alias sudo='sudo '
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias screenoff='DISPLAY=:0 xset dpms force off'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias tmux="tmux -2 -f $XDG_CONFIG_HOME/tmux/tmux.conf"
alias sctl='systemctl'
alias oldvim='/bin/vim'
alias matrixnmap='sudo nmap -v -sS -O'
alias alert='notify-send -i "$([ $? = 0 ] && echo "/usr/share/icons/Adwaita/48x48/emblems/emblem-ok-symbolic.symbolic.png" || echo "/usr/share/icons/Adwaita/48x48/actions/edit-delete-symbolic.symbolic.png")" "$(history 1 | sed '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
#shellcheck disable=2142
alias fix_divinity="cd $HOME/.disks/nvme/media/games/steam/steamapps/common/Divinity\ Original\ Sin\ 2/ && mv ./bin ./bin.bak && ln -s DefEd/bin bin && cd bin && mv ./SupportTool.exe ./SupportTool.bak && ln -s EoCApp.exe SupportTool.exe"
command -v neofetch &>/dev/null ||
    alias neofetch="curl -L --silent https://mendess.xyz/api/v1/file/neofetch | bash"
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'
alias ytdl='youtube-dl'
alias hc=herbstclient
alias ikhal='ikhal; clear'
alias rustfmttoml='cp -v $SPELLS/runes/rustfmt.toml .'
alias raycaster='awk -f <(curl https://raw.githubusercontent.com/TheMozg/awk-raycaster/master/awkaster.awk)'
alias mail='vim +Himalaya'
alias uuid='cat /proc/sys/kernel/random/uuid'
alias ip='ip --color=always'

# Cleanup
command -v julia &>/dev/null && alias julia='HOME=$XDG_CACHE_HOME julia'

alias network_monitor='nmcli -c yes monitor | while read -r line; do echo -e "\e[0m[$(date)] $line"; done'
alias sent-bangers="ssh mendess@mendess.xyz -- jq -r '.[].url' core/mirari/memnarch/files/sent-bangers.json | tac"
