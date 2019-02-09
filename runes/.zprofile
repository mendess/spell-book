export RTV_EDITOR='nvim'
export VISUAL='nvim'
export EDITOR='nvim'
export BROWSER="firefox"
export WWW_HOME='duckduckgo.com/lite'

export PATH=~/.local/bin:$PATH
export PATH=~/.cargo/bin:$PATH

if [[ "$(tty)" == "/dev/tty1" ]]; then
    toilet -f mono9 -F metal "           Starting i3  "
    pgrep i3 || startx > /dev/null
    clear
elif [[ $(tty) == *"tty"* ]]; then
    tmux new-session -s "$(basename $(tty))"
fi
