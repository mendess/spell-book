#!/bin/bash

ls() {
    if hash eza &>/dev/null; then
        eza -g "$@"
    else
        ls --color=auto "$@"
    fi
}

tree() {
    if hash eza &>/dev/null; then
        eza -T "$@"
    else
        ls --color=auto -R "$@"
    fi
}

alias la='ls -la'
alias l='ls -lha'
alias cl="clear; ls -lh"

if hash duf &>/dev/null; then
    alias df=duf
fi

if hash dust &>/dev/null; then
    alias du=dust
fi

if hash bat &>/dev/null; then
    alias bat='bat --theme=base16'
    alias cat='bat -p'
fi

if hash nvim &>/dev/null; then
    alias vim=nvim
fi
