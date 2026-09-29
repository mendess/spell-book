#!/bin/bash

mpv::ytsearch::no_video() {
    mpv --no-video "ytdl://ytsearch:$*"
}

mpv::ytsearch() {
    mpv "ytdl://ytsearch:$*"
}

mpv_get() {
    #shellcheck disable=2119
    echo '{ "command": ["get_property", "'"$1"'"] }' |
        socat - "$(m socket)" |
        jq "${2:-.}" "${@:3}"
}
