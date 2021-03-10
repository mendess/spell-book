#!/bin/bash
alias r='nvm use 8 && npm run index-generate && npm run tsc && npm start'
alias rd='nvm use 8 && npm run index-generate && npm run tsc && NODE_DEBUG=fs npm start'
deploy_to() {
    local host="$1"
    shift
    [[ "$host" ]] || {
        echo 'please specify a host to deploy to'
        return 1
    }
    local root="$1"
    shift
    [[ ! "$root" ]] && root="../$(basename "$(pwd)")"
    local target="$1"
    shift
    [[ ! "$target" ]] && [[ "$root" =~ aclient ]] && target="aclient_new" && root="$root/"
    rsync -av "$root" "$host:$target" \
        --exclude=node_modules \
        --exclude=.git \
        --exclude=build \
        --exclude=tmp \
        --exclude=log \
        --exclude=settings.json \
        --exclude=__pycache__ \
        --exclude=.vim \
        "$@"
}
alias deploy='deploy_to master_image'

