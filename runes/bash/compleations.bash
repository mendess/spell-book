#!/bin/bash

_za() {
	local curw
	curw=${COMP_WORDS[COMP_CWORD]}
    mapfile -t COMPREPLY < <(compgen -o plusdirs -A file -- "$curw" | grep .pdf)
	return
}

_f() {
	local curw
	local files
	curw=${COMP_WORDS[COMP_CWORD]}
	files=$(find "$SPELLS" -type f)
    mapfile -t COMPREPLY < <(compgen -W "$files" -- "$curw")
	return
}

complete -F _za za
complete -F _za pdf
complete -F _f spell
