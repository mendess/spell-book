if has('nvim')
    let mapleader =" "
endif

let work_pc = system('uname -n') =~ '\v.*kaladesh.*'

let g:python3_host_prog = '/usr/bin/python3'
let g:loaded_python_provider = 0

if work_pc && filereadable('/usr/bin/neovim-node-host')
    let g:node_host_prog = '/usr/bin/neovim-node-host'
    let g:coc_node_path = '/usr/bin/node'
endif
source ~/.config/nvim/plugins.vim
source ~/.config/nvim/settings.vim
source ~/.config/nvim/commands.vim
source ~/.config/nvim/keybindings.vim
source ~/.config/nvim/writing.vim

highlight Normal ctermbg=NONE
highlight Normal guibg=NONE
