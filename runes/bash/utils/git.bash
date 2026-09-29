#!/bin/bash

alias gs=gst # fuck ghost script
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
# shellcheck disable=SC2142
alias gbpurge='git fetch --all -p; git branch -vv | grep ": gone]" | awk "{ print \$1 }" | xargs -n 1 --no-run-if-empty git branch -D'
alias gc='git commit -v'
alias 'gc!'='git commit -v --amend'
alias gcwip='git commit -v -mWIP'
alias glog="git log --pretty=format:'%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s' --date=short --graph"
alias glogn='git --no-pager log --oneline --decorate --graph'
gco() {
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
alias gdd='git difftool --tool=vimdiff'
alias gf='git fetch'
alias gl='git pull'
gp() {
    if [ "$(git log --format=format:%ae | sort -u | wc -l)" -gt 1 ]; then
        local b
        b=$(git branch)
        case "$b" in
            main | master | dev | develop)
                read -r -p "You are in '$b', are you sure you want to push? [n/Y] "
                [[ "$REPLY" =~ Y|y ]] || return 0
                ;;
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
    for b in $(git branch --format='%(refname:short)'); do
        case "$b" in
            develop) git switch develop ;;
            dev) git switch dev ;;
            main) git switch main ;;
            master) git switch master ;;
        esac
    done
}
alias gcmm='git checkout main || git checkout master'

# ----- MR management
__guri() {
    git remote get-url --push origin | sed -r 's|[a-z]+@([a-z.-_]+):(.*)(.git)?|https://\1/\2|'
}
gpr() {
    case "$(__guri)" in
        *github*)
            if hash gh; then
                xdg-open "$(__guri)/pull/new/$(git symbolic-ref --short HEAD)"
            else
                gh pr create -a @me
            fi
            ;;
        *gitlab*)
            if hash glab; then
                echo "todo"
            else
                glab mr create --fill --recover --remove-source-branch # --web
            fi
            ;;
    esac
}
alias gfi='xdg-open "$(__guri)"'
alias gpsup='gp --set-upstream origin $(git symbolic-ref --short HEAD)'
alias gpsupr='gpsup && gpr'
alias gsw='git switch'
alias gsw-='git switch -'
gb() {
    if [[ "$1" ]]; then
        git branch "$@"
    else
        git --no-pager branch -vv |
            sed -E 's/ \[[^]]*origin[^]]*\]//' |
            cut -b-"$(tput cols)" |
            GREP_COLORS="mt=1;32" grep --color=always -E '^\* [^/ ]+|' |
            GREP_COLORS="mt=32" grep --color=always -E '^\* [^ ]+|' |
            GREP_COLORS="mt=33" grep --color=always -E ' [a-f0-9]{8,10} |' |
            GREP_COLORS="mt=34" grep --color=always -E '^  [^/]+|'
    fi
}

gcl() {
    if [[ "$(whoami)" = pmendes ]]; then
        mk_repo_dir() {
            project=$(basename "$(dirname "$1")" | rev | cut -d: -f1 | rev)
            mkdir -p "_$project"
            cd "_$project" || return
        }
        undo_on_error() {
            cd ..
            rmdir "_$project"
            return 1
        }
    else
        mk_repo_dir() { :; }
        undo_on_error() { return 1; }
    fi
    case "$1" in
        http://*)
            echo '============================> using http'
            read -r -p 'press enter to continue anyway' &&
                mk_repo_dir "$1" &&
                { git clone "$@" || undo_on_error; }
            ;;
        git@* | https://* | ssh://*)
            mk_repo_dir "$1"
            git clone "$@" || undo_on_error
            ;;
        */*)
            mk_repo_dir "$@"
            git clone git@github.com:"$1" "${@:2}" || undo_on_error
            ;;
        *)
            gh_name=mendess #$(git config --global user.name)
            mk_repo_dir "$gh_name"
            git clone git@github.com:"$gh_name/$1" "${@:2}" || undo_on_error
            ;;
    esac
    #shellcheck disable=SC2181
    [[ "$?" -eq 0 ]] && cd "$(basename "${1%.git}")" || return
}

# ---- gh cli exclusives -----
function wait-for-ci {
    gh run watch
    notify-send "${1:-CI DONE} ${*:2}" -u critical
}
