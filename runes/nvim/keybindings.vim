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
" Open spelling suggestions
nnoremap <A-Enter> z=

" Alt-Tab
map <leader><Tab> <C-^>

" clear search register
nmap <leader><leader> :noh<CR>

" Lock
nnoremap <leader>L :silent !i3lock -t -e --image=/home/mendess/Pictures/Wallpapers/home.png<CR>

" Ctrl C and V to clipboard
inoremap <C-v> <ESC>"+pa
vnoremap <C-c> "+y
vnoremap <C-x> "+d

" Ctrl+q to quit a buffer
nnoremap <C-q> :q<CR>

" Terminal buffer escape to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap <A-[> <Esc>

" Jumps
inoremap ,, <Esc>/<++><Enter>"_c4l
