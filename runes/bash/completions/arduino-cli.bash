#shellcheck disable=SC1090
command -V arduino-cli &>/dev/null &&
    . <(arduino-cli completion bash) &&
    complete -o default -F __start_arduino-cli ard
