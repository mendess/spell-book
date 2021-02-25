#!/bin/bash
alias r='nvm use 8 && npm run tsc && npm start'
alias rd='nvm use 8 && npm run tsc && NODE_DEBUG=fs npm start'
deploy() {
    local root="$1"
    [[ ! "$root" ]] && root="../$(basename "$(pwd)")"
    local target="$2"
    [[ ! "$target" ]] && [[ "$root" =~ aclient ]] && target="aclient_new" && root="$root/"
    rsync -av "$root" "master_image:$target" \
        --exclude=node_modules \
        --exclude=.git \
        --exclude=build
}
