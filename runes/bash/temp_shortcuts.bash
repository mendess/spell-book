#!/bin/bash

alias purge-podspec='gco multiplatform-sdk/src/iosMain/resources/SpeechifySDK.podspec'
alias check-apps='gradle build; ./scripts/check-example-apps.sh'

mac-check() {
    exec 3<>/dev/tcp/phyrexia/8912 || return
    { echo "$(git rev-parse --abbrev-ref HEAD)" >&3 && echo >&3 ; } || return
    read -r -u 3 || return
    echo "$REPLY"
}

sdk() {
    case "$1" in
        c) gradle -Dorg.gradle.jvmargs=-XX:MetaspaceSize=2g check ;;
        b) gradle -Dorg.gradle.jvmargs=-XX:MetaspaceSize=2g build -x test -x jvmTest -x check ;;
        bt) gradle -Dorg.gradle.jvmargs=-XX:MetaspaceSize=2g build ;;
        bc) gradle -Dorg.gradle.jvmargs=-XX:MetaspaceSize=2g build && ./scripts/check-example-apps.sh ;;
        cb) gradle -Dorg.gradle.jvmargs=-XX:MetaspaceSize=2g clean build ;;
        cbc) gradle -Dorg.gradle.jvmargs=-XX:MetaspaceSize=2g clean build && ./scripts/check-example-apps.sh ;;
        fmt) gradle -Dorg.gradle.jvmargs=-XX:MetaspaceSize=2g ktlintformat ;;
        *) gradle -Dorg.gradle.jvmargs=-XX:MetaspaceSize=2g "$@" ;;
    esac
    if [ "$?" = 0 ]; then
        notify-send "Done" "$1" -a sdk
    else
        notify-send "Error" "$1" --urgency critical -a sdk
    fi
}

command -V chromium &>/dev/null && export CHROME_BIN=$(which chromium)
