" COMMANDS
command! W w
command! Q q
command! WQ wq
command! Wq wq
command! V :split ~/.config/nvim/init.vim
command! Vte :vsplit | terminal

command! Json set syntax=json

command! -bang -nargs=1 Rename call RenameFunc(<q-args>, <bang>0)
fu! RenameFunc(new_name, bang)
    let l:aux=expand('%')
    execute 'saveas'.(a:bang?'! ':' ').a:new_name
    execute 'silent !rm -f '.l:aux
endfu
