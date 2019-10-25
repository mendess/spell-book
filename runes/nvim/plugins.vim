if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" Color scheme
Plug 'morhetz/gruvbox'
Plug 'ayu-theme/ayu-vim'

" File browser
Plug 'scrooloose/nerdtree'

" Auto close parens
Plug 'cohama/lexima.vim'

" Zen mode
Plug 'junegunn/goyo.vim'

Plug 'bitc/vim-bad-whitespace'

Plug 'tpope/vim-surround'

Plug 'tpope/vim-commentary'

" Requires: cargo install rustfmt
Plug 'sbdchd/neoformat'

" Syntax highlighting
Plug 'cespare/vim-toml'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'udalov/kotlin-vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

""" PLUGIN CONFIGS

" Gruvbox config
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'hard'

" Ayu config
set termguicolors
let ayucolor="dark"
colorscheme ayu

command! Bt :highlight Normal ctermbg=None
command! Bo :highlight Normal ctermbg=000000

" Nerdtree config
map <F2> :NERDTreeToggle<CR>

" goyo
map <F9> :Goyo<CR>
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
    :set colorcolumn=101
    :highlight Normal ctermbg=None
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
let g:goyo_height='90'
let g:goyo_width='105'

" if has('python3')
"     " deopleate
"     let g:deoplete#enable_at_startup = 1
"     inoremap <silent><expr> <TAB>
"                 \ pumvisible() ? "\<C-n>" :
"                 \ <SID>check_back_space() ? "\<TAB>" :
"                 \ deoplete#manual_complete()
"     function! s:check_back_space() abort "{{{
"         let col = col('.') - 1
"         return !col || getline('.')[col - 1]  =~ '\s'
"     endfunction"}}}

"     set completeopt-=preview

"     " deoplete rust
"     " Requires: rustup component add nightly
"     " Requires: cargo +nightly install racer
"     let g:deoplete#sources#rust#racer_binary = $HOME.'/.cargo/bin/racer'
"     " Requires: rustup component add rust-src
"     let g:deoplete#sources#rust#rust_source_path = $HOME.'/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'

"     " deoplete C
"     let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
"     let g:deoplete#sources#clang#clang_header = '/usr/include/clang/'
" endif

" coc
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> <F10> <Plug>(coc-diagnostic-prev)
nmap <silent> <F12> <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
 " Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" ale
" let g:ale_echo_msg_format = '%linter%: %s'
" nnoremap gd :ALEGoToDefinition<CR>
" nnoremap <F10> :ALEPreviousWrap<CR>
" nnoremap <F12> :ALENextWrap<CR>
" nnoremap <F9> :ALEDetail<CR>

" ale C/C++
let g:ale_cpp_clang_options = '-std=c++2a -Wall -Wextra -pedantic -Iinclude'
let g:ale_cpp_clangtidy_options = '-- -std=c++2a' " -Wall -Wextra -pedantic -Iinclude'
let g:ale_cpp_clangcheck_options = '-- -std=c++2a'
let g:ale_c_parse_makefile = 1
let g:ale_c_parse_compile_commands = 1
let g:ale_cpp_parse_makefile = 1
let g:ale_cpp_parse_compile_commands = 1
let g:ale_linters_ignore = {'cpp': ['gcc', 'clangd'], 'c': ['clang'], 'latex': ['chktex']}

" ale Rust
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')

" Autoformat
map <leader>f :Neoformat<CR>
" autocmd! BufWritePre *.rs :Autoformat
