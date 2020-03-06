if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" Color scheme
Plug 'Mendess2526/ayu-vim'

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
Plug 'rhysd/vim-clang-format'

" Syntax highlighting
Plug 'cespare/vim-toml'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'udalov/kotlin-vim'
Plug 'vim-python/python-syntax'
Plug 'baskerville/vim-sxhkdrc'
Plug 'plasticboy/vim-markdown'

"Plug 'lervag/vimtex'

Plug '/usr/bin/fzf'

Plug 'dense-analysis/ale'

if has('nvim')
    if has('python3')
        Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
        Plug 'Shougo/deoplete.nvim'
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'
    endif
endif

Plug 'andys8/vim-elm-syntax'

if ! has('nvim')
    Plug 'whonore/Coqtail'
endif

Plug 'let-def/vimbufsync'

call plug#end()

""" PLUGIN CONFIGS

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
let g:goyo_width='83'

" coc
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" " Use `[g` and `]g` to navigate diagnostics
" nmap <silent> <F10> <Plug>(coc-diagnostic-prev)
" nmap <silent> <F12> <Plug>(coc-diagnostic-next)
" nmap <silent> gd <Plug>(coc-definition)
"  " Use K to show documentation in preview window
" nnoremap <silent> K :call <SID>show_documentation()<CR>

" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   else
"     call CocAction('doHover')
"   endif
" endfunction

" " Remap for rename current word
" nmap <leader>rn <Plug>(coc-rename)

" " Fix autofix problem of current line
" nmap <leader>qf  <Plug>(coc-fix-current)

" Ale
let g:ale_echo_msg_format = '%linter%: %s'
nnoremap gd :ALEGoToDefinition<CR>
nnoremap <F10> :ALEPreviousWrap<CR>
nnoremap <F12> :ALENextWrap<CR>
nnoremap <F9> :ALEDetail<CR>
let g:ale_cpp_clang_options = '-std=c++2a -Wall -pedantic'
let g:ale_cpp_gcc_options = '-std=c++2a -Wall -pedantic'
let g:ale_linters = { 'rust' : ['cargo'] , 'c': ['clangtidy', 'clangcheck']}
let g:ale_c_parse_compile_commands = 1
let g:ale_c_parse_makefile = 1

" Autoformat
map <leader>f :Neoformat<CR>
augroup fmt
  autocmd!
  autocmd BufWritePre *.c undojoin | Neoformat
  autocmd BufWritePre *.h undojoin | Neoformat
  autocmd BufWritePre *.cpp undojoin | Neoformat
  autocmd BufWritePre *.hpp undojoin | Neoformat
augroup END

" FZZ
nmap <leader>p :FZF<CR>
nmap <leader>P :FZF<CR>

" deoplete
if has('python3')
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#sources#rust#rust_source_path = $HOME.'/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'
    set completeopt-=preview
    let g:deoplete#enable_at_startup = 1
    inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ deoplete#manual_complete()
    function! s:check_back_space() abort "{{{
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~ '\s'
    endfunction"}}}
endif

"autocmd! FileType coq let mapleader='\'
"g:coqtail_nomap = 1
