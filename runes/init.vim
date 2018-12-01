call plug#begin()

Plug 'morhetz/gruvbox'

Plug 'scrooloose/nerdtree'

Plug 'kien/ctrlp.vim'

Plug 'neovimhaskell/haskell-vim'

Plug 'cohama/lexima.vim'

Plug 'elixir-editors/vim-elixir'

Plug 'junegunn/goyo.vim'

Plug 'bitc/vim-bad-whitespace'

" JS shit
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
call plug#end()


" Gruvbox config
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'hard'


" Nerdtree config
map <F2> :NERDTreeToggle<CR>


" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = '\v[\/](\.git|\.hg|\.svn|node_modules|target)$'

" goyo
map <F10> :Goyo<CR>
let g:goyo_height='90'

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" indent using spaces
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab


" Ctrl+S to save
noremap <C-S> :w<CR>

" Reopen current file in a split
command Dup vsplit %:p

" Bind W to w
command W w

" Set the default shell
if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

" LaTeX
autocmd BufEnter *.tex set linebreak
command R !pdflatex Report.tex > /dev/null
command Re !pdflatex Report.tex

syntax on
filetype plugin indent on

:set number relativenumber

" Relative line numbers
:augroup numbertoggle
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END
