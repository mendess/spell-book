runes=( ~/.oh-my-zsh/custom/aliases.zsh ~/.config/nvim/init.vim )

for rune in "${runes[@]}";
do
    echo "Casting "$(basename $rune)
    ln -fsv $(pwd)"/"$(basename $rune) $rune
done
