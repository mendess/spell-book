#!/bin/sh

_extract_desc() {
    path=$1
    find "$path" -maxdepth 1 -type f | sort | while read -r script; do
        desc="$(sed 1d "$script" |
            awk '/^ *#/ {print $0; f=1}
                     f && /^$/ {exit(0)}
                     /^ *[^#]/ {exit(0)}' |
            grep -v shellcheck |
            sed 's/ *# *//g' |
            tr '\n' ' ')"
        s_name="$(basename "$script" | sed -E 's/\.[^.]+$//g')"
        [ "$desc" ] && desc=" - $desc"
        echo " - [$s_name]($script)$desc" | sed 's/\s*$//g'
    done
}

spells() {
    cat <<EOF
## [Spells](./spells/): Scritps to be run by hand or through a keybind.

EOF
    _extract_desc ./spells
}

cantrips() {
    cat <<EOF
## [Cantrips](./cantrips/): Cantrips are scripts lauched from dmenu using the
[menu](./cantrips/menu.sh).

EOF
    _extract_desc ./cantrips
}

runes() {
    cat <<EOF
## [Runes](./runes/): Static configuration files

EOF
}

scrolls() {
    cat <<EOF
## [Scrolls](./scrolls/): Instalation scripts *Mostly untested*

EOF
    _extract_desc ./scrolls
}

cat <<EOF
# Spell Book
 A collection of scripts and dotfiles I like to keep handy.

EOF

for section in spells cantrips runes scrolls; do
    echo
    $section
done
