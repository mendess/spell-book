#!/bin/bash
alias b='nvm use 8 && npm run index-generate && npm run tsc ; nvm use system'
alias r='nvm use 8 && npm run index-generate && npm run tsc && npm start | ./paint_logs.sh ; nvm use system'
alias rd='nvm use 8 && npm run index-generate && npm run tsc && NODE_DEBUG=fs npm start ; nvm use system'
alias t='npm run test'
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
        --exclude=.mypy_cache \
        --exclude=.env \
        "$@"
}
alias deploy='deploy_to master_image'

