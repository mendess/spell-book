return {
    {
        prefix = 'dbg',
        desc = 'insert bash debug mode preamble',
        body = [[shopt -s extdebug
_debug_step() {
    [ "\$BASH_SUBSHELL" -eq 0 ] && return
    case "\$BASH_COMMAND" in
        echo|echo\ *) return 0;;
    esac
    printf "Next: %s\n" "\$BASH_COMMAND" >/dev/tty
    read -r -p "Press Enter to run it..." >/dev/tty </dev/tty
}
trap _debug_step DEBUG
]],
    },
}
