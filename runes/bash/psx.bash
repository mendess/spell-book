#!/bin/bash

__truncPath() {
    pwd | sed -r -e 's!^'"$HOME"'!~!g' -e 's|([^/])[^/]+/|\1/|g' | tr -d '\n'
    return "$1"
}
__rightprompt() {
    [ "$1" -gt 0 ] && printf "<%s>" "$1"
}
__git_branch() {
    if [[ -d .git ]] ||
        [[ -d ../.git ]] ||
        [[ -d ../../.git ]] ||
        [[ -d ../../../.git ]] ||
        [[ -d ../../../../.git ]]; then
        git symbolic-ref HEAD --short | sed -r 's/^(.{10}).*/\1+/g'
    fi
    return "$1"
}

__c() {
    local NO_COLOUR="\e[00m"
    local PRINTING_OFF="\["
    local PRINTING_ON="\]"
    printf "%s%s%s%s%s%s%s" \
        "$PRINTING_OFF" "$1" "$PRINTING_ON" "$2" "$PRINTING_OFF" "$NO_COLOUR" "$PRINTING_ON"
}

YELLOW="\e[0;33m"
RED="\e[1;31m"
BLUE="\e[0;34m"
PS1_PROMPT="> "
PS2_PROMPT="| "
PS4_PROMPT="\$0.\$LINENO+ "
RESTORE_CURSOR_POSITION="\e[u"
SAVE_CURSOR_POSITION="\e[s"
TIMESTAMP="\A"
BATTERY="\$(cat /sys/class/power_supply/BAT0/capacity)% "
SSH_PROMPT="$(__c "$RED" '\u@\h')"
G_BRANCH="\$(__git_branch \$?)"
T_PATH="\$(__truncPath \$?)"
EXIT_STATUS="\$(__rightprompt \$?)"
#TIMESTAMP_PLACEHOLDER="--:--"

move_cursor_to_start_of_ps1() {
    command_rows=$(history 1 | wc -l)
    if [ "$command_rows" -gt 1 ]; then
        ((vertical_movement = command_rows))
    else
        command=$(history 1 | sed 's/^\s*[0-9]*\s*//')
        command_length=${#command}
        ps1_prompt_length=${#PS1_PROMPT}
        ((total_length = command_length + ps1_prompt_length + 1))
        ((lines = total_length / COLUMNS))
        ((vertical_movement = lines + 1))
    fi
    tput cuu $vertical_movement
}

PS0_ELEMENTS=(
    "$SAVE_CURSOR_POSITION" "\$(move_cursor_to_start_of_ps1)"
    "$(__c "$YELLOW" "$TIMESTAMP ")" "$RESTORE_CURSOR_POSITION"
)
PS0=$(
    IFS=
    echo "${PS0_ELEMENTS[*]}"
)
export PS0

PS1_ELEMENTS=()
if [[ "$(tty)" == *tty* ]] && [ -f /sys/class/power_supply/BAT0/capacity ]; then
    PS1_ELEMENTS+=("$BATTERY")
fi
if [ -n "$SSH_CLIENT" ]; then
    PS1_ELEMENTS+=("$SSH_PROMPT" '::')
fi
PS1_ELEMENTS+=(
    "$G_BRANCH" '::<' "$(__c "$YELLOW" "$T_PATH")" "$(__c "$RED" "$EXIT_STATUS")" "> "
)
PS1=$(
    IFS=
    echo "${PS1_ELEMENTS[*]}"
)
export PS1

PS2="$(__c "$BLUE" "$PS2_PROMPT")"
export PS2

PS4="$(__c "$BLUE" "$PS4_PROMPT")"
export PS4
