call plug#begin()

Plug 'morhetz/gruvbox'

Plug 'scrooloose/nerdtree'

Plug 'kien/ctrlp.vim'

Plug 'neovimhaskell/haskell-vim'

Plug 'cohama/lexima.vim'

Plug 'elixir-editors/vim-elixir'

Plug 'junegunn/goyo.vim'

Plug 'bitc/vim-bad-whitespace'

Plug 'PotatoesMaster/i3-vim-syntax'

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

Plug 'tpope/vim-surround'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'sebastianmarkow/deoplete-rust'

Plug 'zchee/deoplete-clang'

" JS shit
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
call plug#end()

""" PLUGIN CONFIGS

" Gruvbox config
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'hard'

" Nerdtree config
map <F2> :NERDTreeToggle<CR>

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = '\v[\/](\.git|\.hg|\.svn|node_modules|target|out)$'

" goyo
map <F10> :Goyo<CR>
let g:goyo_height='90'

" markdown-preview
let g:mkdp_browser = 'firefox'

" deopleate
let g:deoplete#enable_at_startup = 1

" deoplete rust
let g:deoplete#sources#rust#racer_binary = $HOME.'/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path = $HOME.'/rust-source/src'

" deoplete C
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/include/'

""" KEY BINDINGS

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" Ctrl+S to save
noremap <C-S> :w<CR>
let mapleader =" "
" shell script linting
map <leader>s :!clear && shellcheck %<CR>
" toggle spelling
map <leader>o :setlocal spell! spelllang=en_gb,pt_pt<CR>

""" COMMANDS
" Reopen current file in a split
command Dup vsplit %:p
" Bind W to w
command W w
command Q q

""" AUTOCOMMANDS
" clear trailling whitespace
autocmd BufWritePre * %s/\s\+$//e

""" SETTINGS
" indent using spaces
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
" splitbelow and right
set splitbelow splitright
" Set the default shell
if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

syntax on
filetype plugin indent on
" Relative line numbers
:set number relativenumber
:augroup numbertoggle
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END


""" LaTeX
autocmd BufEnter *.tex set linebreak
autocmd BufEnter *.tex command R !pdflatex Report.tex > /dev/null
autocmd BufEnter *.tex command Re !pdflatex Report.tex
" LaTeX snippets
autocmd FileType tex inoremap ,ttt \texttt{}<Esc>T{i
autocmd FileType tex inoremap ,tbf \textbf{}<Esc>T{i
autocmd FileType tex inoremap ,tit \textit{}<Esc>T{i

""" JS
autocmd BufEnter *.js set shiftwidth=2
