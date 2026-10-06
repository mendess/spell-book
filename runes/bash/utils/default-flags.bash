#!/bin/bash

alias bc="bc -lq"
alias grep='grep --color=auto'
alias diff='diff --color=auto'
# shellcheck disable=SC2139
alias tmux="tmux -2 -f $XDG_CONFIG_HOME/tmux/tmux.conf"
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'
alias rmdir='rmdir -v'
alias ip='ip --color=always'
hash julia &>/dev/null && alias julia='HOME=$XDG_CACHE_HOME julia'
alias matrixnmap='sudo nmap -v -sS -O'
alias drag='find -maxdepth 1 -type f | ripdrag --and-exit --no-click --basename --from-stdin'
