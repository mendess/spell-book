#!/bin/bash

alias purge-podspec='gco multiplatform-sdk/src/iosMain/resources/SpeechifySDK.podspec'
alias check-apps='gradle build; ./scripts/check-example-apps.sh'

mac-check() {
    exec 3<>/dev/tcp/new-phyrexia/8912
    echo "$(git rev-parse --abbrev-ref HEAD)" >&3
    read -r -u 3
    echo "$REPLY"
}
