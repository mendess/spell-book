#!/bin/bash

set -e

allows="$(dirname -- "$0")/.install-profile/allows.sh learnSpells"

link_target() {
    realpath "$PWD/$1"
}

spell_name() {
    local v
    case "$1" in
        spells/*.spell)
            v="${1#spells/}"
            v="${v%.spell}"
            ;;
        cantrips/*.sh)
            v="${1%.sh}"
            ;;
        *)
            echo "Error: Invalid spell name: $1" >/dev/stderr
            exit 1
            ;;
    esac
    echo "$v"
}

link_path() {
    local spell_name
    spell_name="$(spell_name "$1")"
    realpath ~/.local/bin/"$spell_name" 2>/dev/null
}

should_learn_spell() {
    {
        local link_path
        ! link_path=$(link_path "$1") ||
            [[ "$link_path" != $(link_target "$1") ]]
    } && {
        grep -v -i termux "$1" >/dev/null || command -V termux-fix-shebang &>/dev/null
    } && {
        local spell_name
        spell_name="$(spell_name "$1")"
        $allows "$spell_name"
    }
}

cleanSpells() {
    for spell in ~/.local/bin/* ~/.local/bin/cantrips/*; do
        if [ -h "$spell" ] && ! [ -e "$spell" ]; then
            echo -e "\033[31mRemoving dead spell: $(basename "$spell")\033[0m"
            rm "$spell"
        fi
    done
    return 0
}

newSpells() {
    for spell in spells/*.spell cantrips/*.sh; do
        if should_learn_spell "$spell" ; then
            echo "$spell"
        fi
    done
}

cd "$(dirname "$(realpath "$0")")" || return 0

cleanSpells

mapfile -t newSpells < <(newSpells)
if [[ "${#newSpells[@]}" -eq 0 ]]; then
    exit 0
fi

echo -e "\033[33mLearning Spells...\033[0m"

mkdir -p ~/.local/bin/cantrips
for spell in "${newSpells[@]}"; do
    echo -e "\033[35m\t$(spell_name "$spell")\033[0m"
    ln -s "$(link_target "$spell")" "$(link_path "$spell")"
done
chmod +x spells/*.spell
echo -e "\033[33mDone!\033[0m"
