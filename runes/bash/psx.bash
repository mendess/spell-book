#!/bin/bash

__truncPath() {
    pwd | sed -r -e 's!^'"$HOME"'!~!g' -e 's|([^/])[^/]+/|\1/|g' | tr -d '\n'
    return "$1"
}

__c() {
    local NO_COLOUR="\e[00m"
    local PRINTING_OFF="\["
    local PRINTING_ON="\]"
    printf "%s%s%s%s%s%s%s" \
        "$PRINTING_OFF" "$1" "$PRINTING_ON" "$2" "$PRINTING_OFF" "$NO_COLOUR" "$PRINTING_ON"
}

__no_new_line_fix() {
  local _ y x _

  IFS='[;' read -p $'\e[6n' -d R -rs _ y x _
  if [[ "$x" != 1 ]]; then
    printf "\n%%"
  fi
  return "$1"
}

__move_cursor_to_start_of_ps1() {
    command_rows=$(history 1 | wc -l)
    if [ "$command_rows" -gt 1 ]; then
        ((vertical_movement = command_rows))
    else
        command=$(history 1 | sed 's/^\s*[0-9]*\s*//')
        command_length=${#command}
        ps1_prompt_length=2 # '> '
        ((total_length = command_length + ps1_prompt_length + 1))
        ((lines = total_length / COLUMNS))
        ((vertical_movement = lines + 1))
    fi
    tput cuu $vertical_movement
}

YELLOW="\e[0;33m"
BLUE="\e[0;34m"

RESTORE_CURSOR_POSITION="\e[u"
SAVE_CURSOR_POSITION="\e[s"
TIMESTAMP="\A"

T_PATH='$(__truncPath $?)'
NO_NEW_LINE_FIX='$(__no_new_line_fix $?)'

PS0_ELEMENTS=(
    "$SAVE_CURSOR_POSITION" "\$(__move_cursor_to_start_of_ps1)"
    "$(__c "$YELLOW" "$TIMESTAMP ")" "$RESTORE_CURSOR_POSITION"
    "\$(stty susp ^z)"
    "\\e]2;::<$T_PATH> \$(history 1 | cut -d' ' -f3-)\\a"
)
PS0=$(
    IFS=
    echo "${PS0_ELEMENTS[*]}"
)

PS1='$(__no_new_line_fix $?)$($SPELLS/runes/bash/helpers/ps1.crs $? "$(jobs)")'

PS2="$(__c "$BLUE" "| ")"

PS4="$(__c "$BLUE" "\$0:\$LINENO: ")"
