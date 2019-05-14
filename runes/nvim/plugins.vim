if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

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

if has('python3')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

    Plug 'sebastianmarkow/deoplete-rust'

    Plug 'zchee/deoplete-clang'

    Plug 'deoplete-plugins/deoplete-jedi'
endif

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
    :highlight ColorColumn ctermbg=Black
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

set completeopt-=preview

" deoplete rust
""" Requires: rustup component add nightly
""" Requires: cargo +nightly install racer
let g:deoplete#sources#rust#racer_binary = $HOME.'/.cargo/bin/racer'
""" Requires: rustup component add rust-src
let g:deoplete#sources#rust#rust_source_path = $HOME.'/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'

" deoplete C
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/include/clang/'

" ale
let g:ale_echo_msg_format = '%linter%: %s'
nnoremap gd :ALEGoToDefinition<CR>
nnoremap <F11> :ALEPreviousWrap<CR>
nnoremap <F12> :ALENextWrap<CR>
nnoremap <F9> :ALEDetail<CR>

" ale C/C++
let g:ale_cpp_clang_options = '-std=c++20 -Wall -Wextra -pedantic'
let g:ale_c_parse_makefile = 1
let g:ale_c_parse_compile_commands = 1
let g:ale_linters_ignore = {'cpp': ['gcc']}

" ale Rust
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')

" Autoformat
map <leader>f :Autoformat<CR>
autocmd! BufWritePre *.rs :Autoformat
