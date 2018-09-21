set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
Plugin 'vim-scripts/indentpython.vim'

"Bundle 'Valloric/YouCompleteMe'
" DEPENDENCIES  sudo apt-get install build-essential cmake
" 		sudo apt-get install python-dev python3-dev
" 		cd ~/.vim/bundle/YouCompleteMe
" 		./install.py --clang-completer
"Bundle 'rdnetto/YCM-Generator'
"let g:ycm_autoclose_preview_window_after_insertion = 1
"let g:ycm_confirm_extra_conf = 0
"let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

Plugin 'vim-syntastic/syntastic'
" https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/#Virtualenv-Support
Plugin 'nvie/vim-flake8'
Plugin 'bitc/vim-bad-whitespace'
Plugin 'jnurmine/Zenburn'
Plugin 'scrooloose/nerdtree'
Plugin 'morhetz/gruvbox'
Plugin 'elixir-editors/vim-elixir'
Plugin 'racer-rust/vim-racer'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" color scheme
" set rtp+=~/.vim/bundle/gruvbox/colors/gruvbox.vim
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'
set background=dark    " Setting dark mode

" Enable folding
set foldmethod=indent
set foldlevel=99

set encoding=utf-8

set nu


"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

map <F2> :NERDTreeToggle<CR>

autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

let python_highlight_all=1
syntax on

au FileType perl set filetype=prolog

