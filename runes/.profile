export RTV_EDITOR='nvim'
export VISUAL='nvim'
export EDITOR='nvim'
export BROWSER="firefox"
export WWW_HOME='duckduckgo.com/lite'

export PATH=~/.local/bin:$PATH

if [[ "$(tty)" = "/dev/tty1" ]]; then
    pgrep i3 || startx
fi
