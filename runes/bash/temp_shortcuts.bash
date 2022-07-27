#!/bin/bash

mac-check() {
    exec 3<>/dev/tcp/phyrexia/8912 || return
    { echo "$(git rev-parse --abbrev-ref HEAD)" >&3 && echo >&3 ; } || return
    read -r -u 3 || return
    echo "$REPLY"
}

sdk() {
    case "$1" in
        c) ./gradlew -Dorg.gradle.jvmargs=-XX:MetaspaceSize=2g check "${@:2}" ;;
        b) ./gradlew -Dorg.gradle.jvmargs=-XX:MetaspaceSize=2g build "${@:2}" -x test -x jvmTest -x check ;;
        bt) ./gradlew -Dorg.gradle.jvmargs=-XX:MetaspaceSize=2g build "${@:2}" ;;
        bc) ./gradlew -Dorg.gradle.jvmargs=-XX:MetaspaceSize=2g build && ./scripts/check-example-apps.sh "${@:2}" ;;
        cb) ./gradlew -Dorg.gradle.jvmargs=-XX:MetaspaceSize=2g clean build "${@:2}" ;;
        cbc) ./gradlew -Dorg.gradle.jvmargs=-XX:MetaspaceSize=2g clean build && ./scripts/check-example-apps.sh "${@:2}" ;;
        fmt) ./gradlew -Dorg.gradle.jvmargs=-XX:MetaspaceSize=2g ktlintformat "${@:2}" ;;
        *) ./gradlew -Dorg.gradle.jvmargs=-XX:MetaspaceSize=2g "$@" ;;
    esac
    if [ "$?" = 0 ]; then
        if command -V notify-send 2>/dev/null; then
            notify-send "Done" "$1" -a sdk
        elif command -V terminal-notifier 2>/dev/null; then
            terminal-notifier Done
        fi
    else
        if command -V notify-send 2>/dev/null; then
            notify-send "Error" "$1" --urgency critical -a sdk
        elif command -V terminal-notifier 2>/dev/null; then
            terminal-notifier Error
        fi
    fi
}

command -V chromium &>/dev/null && export CHROME_BIN=$(which chromium)
