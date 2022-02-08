#!/bin/bash

alias purge-podspec='gco multiplatform-sdk/src/iosMain/resources/SpeechifySDK.podspec'
alias check-apps='gradle build; ./scripts/check-example-apps.sh'

mac-check() {
    exec 3<>/dev/tcp/new-phyrexia/8912 || return
    { echo "$(git rev-parse --abbrev-ref HEAD)" >&3 && echo >&3 ; } || return
    read -r -u 3 || return
    echo "$REPLY"
}

sdk() {
    case "$1" in
        c) gradle check ;;
        b) gradle build ;;
        bc) gradle build && ./scripts/check-example-apps.sh ;;
        cb) gradle clean build ;;
        cbc) gradle clean build && ./scripts/check-example-apps.sh ;;
        fmt) gradle ktlintformat ;;
        *) gradle "$@" ;;
    esac
    if [ "$?" = 0 ]; then
        notify-send "Done" "$1" -a sdk
    else
        notify-send "Error" "$1" --urgency critical -a sdk
    fi
}
