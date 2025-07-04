#!/bin/bash

trap '' STOP

__truncPath() {
    pwd | sed -r -e 's!^'"$HOME"'!~!g' -e 's|([^/])[^/]+/|\1/|g' | tr -d '\n'
    return "$1"
}
__rightprompt() {
    # 148 is the sig stop code, so I can Ctrl+Z without getting an error
    [ "$1" -gt 0 ] && [ "$1" -ne 148 ] && printf "<%s>" "$1"
}

__git_branch() {
    if [[ -e .git ]] ||
        [[ -e ../.git ]] ||
        [[ -e ../../.git ]] ||
        [[ -e ../../../.git ]] ||
        [[ -e ../../../../.git ]]; then
        if [ -n "$SSH_CLIENT" ]; then
            printf '::'
        fi
        git symbolic-ref HEAD --short 2>/dev/null |
            sed -r -e 's|([^/][^/]?)[^/]+/|\1/|g' -e 's/^(.{10}).*/\1+/'
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

__has_n_job() {
    if [[ "$(jobs | grep -c 'Stopped')" -eq "$1" ]]; then
        printf ::
    fi
    return "$2"
}

__has_more_than_job() {
    if [[ "$(jobs | grep -c 'Stopped')" -gt $1 ]]; then
        printf ::
    fi
    return "$2"
}

__no_new_line_fix() {
  local _ y x _
  local LIGHT_YELLOW="\001\033[1;93m\002"
  local     RESET="\001\e[0m\002"

  IFS='[;' read -p $'\e[6n' -d R -rs _ y x _
  if [[ "$x" != 1 ]]; then
    printf "\n%%"
  fi
  return "$1"
}

BOLD_RED="\e[1;31m"
BOLD_GREEN="\e[1;32m"
BOLD_YELLOW="\e[1;33m"
BOLD_BLUE="\e[1;34m"
BOLD_MAGENTA="\e[1;35m"
BOLD_CYAN="\e[1;36m"
BOLD_GRAY="\e[1;2m"
RED="\e[0;31m"
GREEN="\e[0;32m"
YELLOW="\e[0;33m"
BLUE="\e[0;34m"
MAGENTA="\e[0;35m"

PS1_PROMPT="> "
PS2_PROMPT="| "
PS4_PROMPT="\$0.\$LINENO+ "
RESTORE_CURSOR_POSITION="\e[u"
SAVE_CURSOR_POSITION="\e[s"
TIMESTAMP="\A"
BATTERY="\$(cat /sys/class/power_supply/BAT0/capacity)% "
case "$(hostname)" in
    tolaria)
        hostname_color=$BOLD_BLUE
        ;;
    weatherlight | kaladesh)
        hostname_color=$BOLD_CYAN
        ;;
    mirrodin)
        hostname_color=$BOLD_GRAY
        ;;
    argentum)
        hostname_color=$BOLD_YELLOW
        ;;
    *)
        hostname_color=$BOLD_GREEN
        ;;
esac

SSH_PROMPT="$(__c "$BOLD_RED" '\u')@$(__c "$hostname_color" '\h')"
G_BRANCH='$(__git_branch $?)'
T_PATH='$(__truncPath $?)'
EXIT_STATUS='$(__rightprompt $?)'
NO_JOB='$(__has_n_job 0 $?)'
ONE_JOB=$(__c "$MAGENTA" '$(__has_n_job 1 $?)')
TWO_JOB=$(__c "$BLUE" '$(__has_n_job 2 $?)')
THREE_JOB=$(__c "$YELLOW" '$(__has_n_job 3 $?)')
FOUR_JOB=$(__c "$GREEN" '$(__has_n_job 4 $?)')
LOTS_JOB=$(__c "$RED" '$(__has_more_than_job 4 $?)')
NO_NEW_LINE_FIX='$(__no_new_line_fix $?)'
JOBS=("$NO_JOB" "$ONE_JOB" "$TWO_JOB" "$THREE_JOB" "$FOUR_JOB" "$LOTS_JOB")

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
    "\$(stty susp ^z)"
    "\\e]2;::<$T_PATH> \$(history 1 | cut -d' ' -f3-)\\a"
)
PS0=$(
    IFS=
    echo "${PS0_ELEMENTS[*]}"
)
export PS0

PS1_ELEMENTS=("$NO_NEW_LINE_FIX")
if { [[ "$(tty)" == *tty* ]] || [ "$TTY_TMUX" ]; } && [ -f /sys/class/power_supply/BAT0/capacity ]; then
    PS1_ELEMENTS+=("$BATTERY")
fi
if [[ -n "$SSH_CLIENT" ]]; then
    PS1_ELEMENTS+=("$SSH_PROMPT")
fi
PS1_ELEMENTS+=(
    "$G_BRANCH" "${JOBS[@]}" '<'
    "$(__c "$YELLOW" "$T_PATH")" "$(__c "$BOLD_RED" "$EXIT_STATUS")"
    '> '
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
