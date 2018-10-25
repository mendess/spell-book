call plug#begin()

Plug 'morhetz/gruvbox'

Plug 'scrooloose/nerdtree'

Plug 'kien/ctrlp.vim'

Plug 'neovimhaskell/haskell-vim'

Plug 'cohama/lexima.vim'

Plug 'pangloss/vim-javascript'

Plug 'elixir-editors/vim-elixir'

Plug 'junegunn/goyo.vim'

Plug 'bitc/vim-bad-whitespace'

call plug#end()

" vimroom config
" let g:vimroom_background = 'black'
let g:vimroom_ctermbackground="none"


" Gruvbox config
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'hard'


" Nerdtree config
map <F2> :NERDTreeToggle<CR>


" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

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


syntax on
filetype plugin indent on

:set number relativenumber

" Relative line numbers
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END
