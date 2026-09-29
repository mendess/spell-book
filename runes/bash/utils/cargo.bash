#!/bin/bash

# CARGO
alias c=cargo
alias cr='cargo run'
alias cb='cargo build'
alias crr='cargo run --release'
alias cbr='cargo build --release'
alias cch='cargo clippy'

ct() {
    if hash cargo-nextest &>/dev/null; then
        cargo nextest run
    else
        cargo test
    fi
}

alias c+='cargo +nightly'
alias c+r='cargo +nightly run'
alias c+b='cargo +nightly build'
alias c+rr='cargo +nightly run --release'
alias c+br='cargo +nightly build --release'
alias c+ch='cargo +nightly check'
alias c+t='cargo +nightly test'

rs() {
    if hash evcxr &>/dev/null; then
        evcxr --edit-mode vi
    else
        echo 'evcxr' command not found. Install it with 'cargo install evcxr_repl'
    fi
}
