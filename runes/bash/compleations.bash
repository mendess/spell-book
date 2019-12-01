#!/bin/bash

_za() {
	local curw
	curw=${COMP_WORDS[COMP_CWORD]}
    mapfile -t COMPREPLY < <(compgen -o plusdirs -A file -- "$curw" | grep .pdf)
	return
}

complete -F _za za
complete -F _za pdf

_svim() {
	local curw
	local files
	curw=${COMP_WORDS[COMP_CWORD]}
	files=$(find "$SPELLS" -type f | sed '/\.git/d ; s|'"$SPELLS"'/||g')
    mapfile -t COMPREPLY < <(compgen -W "$files" -- "$curw")
	return
}

complete -F _svim svim

_ssh()
{
    local cur opts
    # local prev
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    #prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(grep '^Host' ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null | grep -v '[?*]' | cut -d ' ' -f 2-)
    mapfile -t COMPREPLY < <(compgen -W "$opts" -- "$cur")
    return 0
}

complete -F _ssh ssh
