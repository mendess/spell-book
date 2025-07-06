_ssh() {
    local opts
    # local prev
    local cur="${COMP_WORDS[COMP_CWORD]}"
    #prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(grep '^Host' ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null |
        grep -v '[?*]' |
        cut -d ' ' -f 2-)
    mapfile -t COMPREPLY < <(compgen -W "$opts" -- "$cur")
    return 0
}

complete -F _ssh ssh
