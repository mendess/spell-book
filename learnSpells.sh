#!/bin/bash

spell_name() {
    case "$1" in
        spells/*.spell)
            v="${1#spells/}"
            v="${v%.spell}"
            ;;
        cantrips/*.sh)
            v="${v%.sh}"
            ;;
        *)
            echo "Error: Invalid spell name: $1"
            exit 1
            ;;
    esac
    echo "$v"
}

cleanSpells() {
    for spell in ~/.local/bin/* ~/.local/bin/cantrips/*; do
        if [ -h "$spell" ] && ! [ -e "$spell" ]; then
            echo -e "\033[31mRemoving dead spell: $(basename "$spell")\033[0m"
            rm "$spell"
        fi
    done
    return 1
}

newSpells() {
    for spell in spells/*.spell cantrips/*.sh; do
        spell_name="$(spell_name "$spell")"
        [ -h ~/.local/bin/"$spell_name" ] || return 0
    done
    return 1
}

mkdir -p ~/.local/bin/crafted
cd "$(dirname "$(realpath "$0")")" || return 0

cleanSpells
newSpells || exit 0

echo -e "\033[33mLearning Spells...\033[0m"

mkdir -p ~/.local/bin/cantrips
for spell in spells/*.spell cantrips/*.sh; do
    spell_name="$(spell_name "$spell")"
    if ! [ -h ~/.local/bin/"$spell_name" ]; then
        echo -e "\033[35m\t$spell_name\033[0m"
        ln -s "$(pwd)/$spell" ~/.local/bin/"$spell_name"
    fi
done
chmod +x spells/*.spell
echo -e "\033[33mDone!\033[0m"
