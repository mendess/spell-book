if has('nvim')
    let mapleader =" "
endif

let g:python3_host_prog = '/usr/bin/python3'
let g:loaded_python_provider = 0

source ~/.config/nvim/plugins.vim
source ~/.config/nvim/settings.vim
source ~/.config/nvim/commands.vim
source ~/.config/nvim/keybindings.vim
source ~/.config/nvim/writing.vim
source ~/.config/nvim/boilerplate.vim

highlight Normal ctermbg=NONE
highlight Normal guibg=NONE
