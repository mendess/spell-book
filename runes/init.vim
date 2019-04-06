call plug#begin()

Plug 'morhetz/gruvbox'

Plug 'scrooloose/nerdtree'

Plug 'kien/ctrlp.vim'

Plug 'cohama/lexima.vim'

Plug 'junegunn/goyo.vim'

Plug 'bitc/vim-bad-whitespace'

Plug 'PotatoesMaster/i3-vim-syntax'

Plug 'tpope/vim-surround'

Plug 'tpope/vim-commentary'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'sebastianmarkow/deoplete-rust'

Plug 'zchee/deoplete-clang'

Plug 'w0rp/ale'

Plug 'AndrewRadev/splitjoin.vim'

" Requires: cargo install rustfmt
Plug 'Chiel92/vim-autoformat'

Plug 'cespare/vim-toml'

Plug 'octol/vim-cpp-enhanced-highlight'

call plug#end()

""" PLUGIN CONFIGS

" Gruvbox config
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'hard'
command! Bt :highlight Normal ctermbg=None
command! Bo :highlight Normal ctermbg=000000

" Nerdtree config
map <F2> :NERDTreeToggle<CR>

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = '\v[\/](\.git|\.hg|\.svn|node_modules|target|out)$'

" goyo
map <F10> :Goyo<CR>
function! s:goyo_enter()
    :set nonumber norelativenumber
    :autocmd! numbertoggle
endfunction

function! s:goyo_leave()
    :set number relativenumber
    :augroup numbertoggle
    :  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    :  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
    :augroup END
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
let g:goyo_height='90'

" deopleate
let g:deoplete#enable_at_startup = 1
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ deoplete#manual_complete()
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

" deoplete rust
""" Requires: rustup component add nightly
""" Requires: cargo +nightly install racer
let g:deoplete#sources#rust#racer_binary = $HOME.'/.cargo/bin/racer'
""" Requires: rustup component add rust-src
let g:deoplete#sources#rust#rust_source_path = $HOME.'/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'

" deoplete C
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/include/'
" ALE C
" autocmd BufEnter *.c let b:ale_linters = ['clang `pkg-config --libs -cflags glib-2.0`']

""" KEY BINDINGS

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <M-h> <C-w>H
nnoremap <M-j> <C-w>J
nnoremap <M-k> <C-w>K
nnoremap <M-l> <C-w>L

" Ctrl+S to save
map <C-S> :w<CR>
imap <C-S> <Esc>:w<CR>a

let mapleader =" "
" shell script linting
map <leader>s :!clear && shellcheck %<CR>
" toggle spelling
map <leader>o :setlocal spell! spelllang=en_gb,pt_pt<CR>
map <leader>O :setlocal spell! spelllang=en_gb<CR>
" Alt-Tab
map <leader><Tab> :e #<CR>
" clear search results
nmap <leader><leader> :noh<CR>

" Lock
nnoremap <leader>L :silent !i3lock -t -e --image=/home/mendess/Pictures/Wallpapers/home.png<CR>

inoremap <C-v> <ESC>"+pa
vnoremap <C-c> "+y
vnoremap <C-x> "+d

nnoremap <A-Enter> z=

map <leader>f :Autoformat<CR>

nnoremap gd <C-[>

nnoremap <C-q> :q<CR>

""" COMMANDS
" Reopen current file in a split
command! Dup vsplit %:p
" Bind W to w
command! W w
command! Q q
command! WQ wq
command! V :split ~/.config/nvim/init.vim | :source ~/.config/nvim/init.vim
command! C :!ctags -R .

""" AUTOCOMMANDS
" clear trailling whitespace
autocmd! BufWritePre * %s/\s\+$//e
autocmd! BufWritePre *.rs :Autoformat
autocmd! BufNewFile,BufRead *.spell set syntax=sh

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
set foldmethod=indent
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

""" Jumps
inoremap ,, <Esc>/<++><Enter>"_c4l
inoremap ,mks <++>
""" LaTeX
autocmd BufEnter *.tex set linebreak
autocmd FileType tex map <leader>r :silent !pdflatex  --shell-escape %:p > /dev/null &<Return>
autocmd BufEnter *.tex command! Re !pdflatex --shell-escape %:p
" LaTeX snippets
autocmd FileType tex inoremap ,tt \texttt{}<Space><++><Esc>T{i
autocmd FileType tex inoremap ,ve \verb!!<Space><++><Esc>T!i
autocmd FileType tex inoremap ,bf \textbf{}<Space><++><Esc>T{i
autocmd FileType tex inoremap ,it \textit{}<Space><++><Esc>T{i
autocmd FileType tex inoremap ,st \section{}<Return><Return><++><Esc>2kt}a
autocmd FileType tex inoremap ,sst \subsection{}<Return><Return><++><Esc>2kt}a
autocmd FileType tex inoremap ,ssst \subsubsection{}<Return><Return><++><Esc>2kt}a
autocmd FileType tex inoremap ,bit \begin{itemize}<CR><CR>\end{itemize}<Return><++><Esc>kki<Tab>\item<Space>
autocmd FileType tex inoremap ,bfi \begin{figure}[H]<CR><CR>\end{figure}<Return><++><Esc>kki<Tab>\includegraphics{}<CR>\caption{<++>}<Esc>k$i
autocmd FileType tex inoremap ,beg \begin{<++>}<Esc>yyp0fbcwend<Esc>O<Tab><++><Esc>k0<Esc>/<++><Enter>"_c4l
autocmd FileType tex inoremap ~a ã
autocmd FileType tex inoremap `a à
autocmd FileType tex inoremap `A A
autocmd FileType tex inoremap `e é
autocmd FileType tex inoremap `E É
autocmd FileType tex inoremap `o ó
autocmd FileType tex inoremap `u ú
autocmd FileType tex noremap  <buffer> <silent> k gk
autocmd FileType tex noremap  <buffer> <silent> j gj
autocmd FileType tex noremap  <buffer> <silent> 0 g0
autocmd FileType tex noremap  <buffer> <silent> $ g$

autocmd BufEnter *.sh    inoremap ,bb #!/bin/bash<Esc>o
autocmd BufEnter *.spell inoremap ,bb #!/bin/bash<Esc>o

""" Markdown
autocmd BufEnter *.md set linebreak
autocmd FileType markdown inoremap ~a ã
autocmd FileType markdown inoremap `a à
autocmd FileType markdown inoremap `A A
autocmd FileType markdown inoremap `e é
autocmd FileType markdown inoremap `E É
autocmd FileType markdown inoremap `o ó
autocmd FileType markdown inoremap `u ú
autocmd FileType markdown noremap  <buffer> <silent> k gk
autocmd FileType markdown noremap  <buffer> <silent> j gj
autocmd FileType markdown noremap  <buffer> <silent> 0 g0
autocmd FileType markdown noremap  <buffer> <silent> $ g$

""" JS
autocmd! BufEnter *.js set shiftwidth=2

