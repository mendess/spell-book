return {
    {
        prefix = 'dbg',
        desc = 'insert bash debug mode preamble',
        body = [[shopt -s extdebug
_debug_step() {
    printf "Next: %s\n" "\$BASH_COMMAND" >/dev/tty
    read -r -p "Press Enter to run it..." >/dev/tty </dev/tty
}
trap _debug_step DEBUG
]],
    },
}
