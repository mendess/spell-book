" split navigations
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h

nnoremap <M-h> <C-w>H
nnoremap <M-j> <C-w>J
nnoremap <M-k> <C-w>K
nnoremap <M-l> <C-w>L

" split resize
nnoremap <M-K> <C-w>+
nnoremap <M-J> <C-w>-
nnoremap <M-H> <C-w><
nnoremap <M-L> <C-w>>

" Fix Y
nnoremap Y y$

" Ctrl+S to save
noremap <C-S> :w<CR>
inoremap <C-S> <Esc>:w<CR>a

" shell script linting
au FileType sh map <leader>s :!clear && shellcheck --color=never -x %<CR>
" toggle spelling
noremap <leader>o :setlocal spell! spelllang=en_gb,pt_pt<CR>
noremap <leader>O :setlocal spell! spelllang=en_gb<CR>
" Open spelling suggestions
nnoremap <C-Enter> z=

" Alt-Tab
noremap <leader><Tab> <C-^>

" clear search register
nnoremap <leader><leader> :noh<CR>

" Lock
nnoremap <leader>L :silent !i3lock -t -e --image=/home/mendess/Pictures/Wallpapers/home.png<CR>

" Ctrl C and V to clipboard
" inoremap <C-v> <ESC>"+pa
vnoremap <C-c> "+y
vnoremap <C-x> "+d

" Ctrl+q to quit a buffer
nnoremap <C-q> :q<CR>

" Terminal buffer escape to normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap <A-[> <Esc>

" Jumps
inoremap ,, <Esc>/<++><Enter>"_c4l

"
vnoremap // y/\V<C-R>"<CR>

inoremap <C-A> <Esc>$a<space><Esc>y^$a=<space><C-R>=<C-R>0<CR>
vnoremap <C-M> y`>a<space>=<space><C-R>=<C-R>"<CR>

inoremap <S-Tab> <C-V><Tab>

" Fast replace
nnoremap s :%s//<Left>
nnoremap S :%s/\<<C-r><C-w>\>/
vnoremap s :s//<Left>

" Save, compile and run
au FileType c nnoremap <leader>r :call CompileC()<CR>
fu! CompileC()
    write
    if filereadable('makefile') || filereadable('Makefile')
        make
    else
        make %:r
        !./%:r
    endif
endfu
nnoremap <leader>z :set foldmethod=indent<CR>
