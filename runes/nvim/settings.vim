" indent using spaces
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
autocmd! BufEnter *.css set tabstop=2 shiftwidth=2
autocmd! BufEnter *.scss set tabstop=2 shiftwidth=2
autocmd! BufEnter *.html set tabstop=2 shiftwidth=2
" splitbelow and right
set splitbelow splitright
" make path recursive
set path=**
" Set the default shell
if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif
" set foldmethod=indent
set nofoldenable

syntax on
filetype plugin indent on
" Relative line numbers
:set number relativenumber
:augroup numbertoggle
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

" Number of lines between cursor and scroll
set scrolloff=4
" Don't close buffers that aren't bound to a window
set hidden
" smartcase matching
set ignorecase
set smartcase

""" AUTOCOMMANDS
autocmd! BufLeave,BufHidden ~/.config/nvim/init.vim :so ~/.config/nvim/init.vim
" clear trailling whitespace
autocmd! BufWritePre * %s/\s\+$//e
autocmd! BufNewFile,BufRead *.spell set syntax=sh
autocmd! BufEnter *xinitrc set syntax=sh
autocmd! BufNewFile,BufRead *.glsl set syntax=c
autocmd! BufNewFile,BufRead *.hbs set syntax=html

autocmd! BufEnter *.sh    inoremap ,bb #!/bin/sh<Esc>o
autocmd! BufEnter *.spell inoremap ,bb #!/bin/sh<Esc>o

autocmd! BufEnter *.js set shiftwidth=2

if has("nvim")
    autocmd! TermEnter * setlocal nonumber
    autocmd! TermEnter * setlocal norelativenumber
    autocmd! TermEnter * autocmd! numbertoggle
endif

highlight ColorColumn ctermbg=Black
set colorcolumn=101
autocmd! BufEnter *.c set colorcolumn=81
autocmd! BufEnter *.h set colorcolumn=81
autocmd! BufEnter *.cpp set colorcolumn=81
autocmd! BufEnter *.hpp set colorcolumn=81
autocmd! BufLeave *.c set colorcolumn=101
autocmd! BufLeave *.h set colorcolumn=101
autocmd! BufLeave *.cpp set colorcolumn=101
autocmd! BufLeave *.hpp set colorcolumn=101
highlight Normal ctermbg=None

set undodir=~/.cache/vimundo
set undofile

" syntax concealment
set conceallevel=2

iabbrev ture true
iabbrev stirng string
iabbrev Stirng String
iabbrev tho though
iabbrev flase false
iabbrev Flase False
iabbrev slef self
iabbrev Slef Self
iabbrev cosnt const

if has("gui_running")
    set tb=
    set go=
endif

set showcmd

" I don't need help
:nmap <F1> :echo<CR>
:imap <F1> <C-o>:echo<CR>

"pum transparency
if has('nvim')
    set pumblend=15
endif

set mouse=n
