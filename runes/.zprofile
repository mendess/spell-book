export RTV_EDITOR='nvim'
export VISUAL='nvim'
export EDITOR='nvim'
export BROWSER="firefox"
export WWW_HOME='duckduckgo.com/lite'

export PATH=~/.local/bin:$PATH
export PATH=~/.cargo/bin:$PATH
export PAGER="less"
export LESS_TERMCAP_mb=$'\e[1;35m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;32m'

if [[ "$(tty)" == "/dev/tty1" ]]; then
    toilet -f mono9 -F metal "           Starting i3  "
    pgrep i3 || startx > /dev/null
    clear
elif [[ $(tty) == *"tty"* ]]; then
    tmux new-session -s "$(basename $(tty))"
fi
