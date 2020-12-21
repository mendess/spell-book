if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'salsifis/vim-transpose'

" Color scheme
Plug 'Mendess2526/ayu-vim'
Plug 'chriskempson/base16-vim'
Plug 'ntk148v/vim-horizon'

" File browser
Plug 'scrooloose/nerdtree'

" Auto close parens
"Plug 'cohama/lexima.vim'
Plug 'jiangmiao/auto-pairs'

Plug 'bitc/vim-bad-whitespace'

Plug 'tpope/vim-surround'
Plug 'alvan/vim-closetag'

Plug 'tpope/vim-commentary'

Plug 'tpope/vim-repeat'

Plug 'tpope/vim-abolish'

Plug 'machakann/vim-highlightedyank'

" Requires: cargo install rustfmt
Plug 'sbdchd/neoformat'
Plug 'rhysd/vim-clang-format'

" Syntax highlighting
" Plug 'cespare/vim-toml'
" Plug 'octol/vim-cpp-enhanced-highlight'
" Plug 'udalov/kotlin-vim'
" Plug 'vim-python/python-syntax'
" Plug 'baskerville/vim-sxhkdrc'
" Plug 'plasticboy/vim-markdown'
" Plug 'JuliaEditorSupport/julia-vim'
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'sheerun/vim-polyglot'

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

if ! has('nvim')
    Plug 'whonore/Coqtail'
    Plug 'let-def/vimbufsync'
endif

Plug 'rust-lang/rust.vim'

" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }

Plug 'godlygeek/tabular'

Plug 'chrisbra/unicode.vim'

Plug 'chrisbra/csv.vim'

call plug#end()

""" PLUGIN CONFIGS

" Ayu config
set termguicolors
let base16colorspace=256  " Access colors present in 256 colorspace
let ayucolor="dark"
"colorscheme ayu
colorscheme base16-default-dark
"colorscheme base16-default-light

command! Bt :highlight Normal ctermbg=NONE | :highlight Normal guibg=NONE
command! Bo :colorscheme base16-default-dark

" Nerdtree config
map <F2> :NERDTreeToggle<CR>
imap <F2> :NERDTreeToggle<CR>
let NERDTreeSortOrder=['include/$', 'src/$']

" highlightedyank
let g:highlightedyank_highlight_duration = 100

" Ale
nnoremap gd :ALEGoToDefinition<CR>
nnoremap <F10> :ALEPreviousWrap<CR>
nnoremap <F12> :ALENextWrap<CR>
nnoremap <F9> :ALEDetail<CR>
let g:ale_echo_msg_format = '%linter%: %s'
let g:ale_linters = {
    \ 'rust' : ['analyzer'],
    \ 'c': ['ccls', 'clangtidy', 'clangcheck'],
    \ 'cpp': ['ccls','g++','clangtidy','clang++'],
    \ 'tex': ['alex', 'chktex', 'proselint', 'redpen',
    \         'texlab', 'textlint', 'vale', 'writegood']
    \ }
let g:ale_fixers = { 'rust': ['rustfmt'] }

let g:ale_cpp_clang_options = '-std=c++2a -Wall -pedantic'
let g:ale_cpp_gcc_options = '-std=c++2a -Wall -pedantic'
let g:ale_cpp_clangtidy_options = '-std=c++2a'
let g:ale_c_clangtidy_options = '-x c'
let g:ale_c_parse_compile_commands = 1
let g:ale_c_parse_makefile = 1
let g:ale_rust_cargo_check_tests = 1
let g:ale_rust_cargo_default_feature_behavior = 'all'
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
let g:ale_rust_rls_config = {
	\ 'rust': {
		\ 'all_targets': 1,
		\ 'build_on_save': 1,
		\ 'clippy_preference': 'on'
	\ }
\ }
let g:ale_rust_rls_toolchain = ''
let g:ale_rust_rls_executable = 'rust-analyzer'


" Autoformat
map <leader>f :Neoformat<CR>
let g:shfmt_opt="-ci"
let g:rustfmt_opt="--edition 2018"

" FZF
nmap <leader>p :FZF<CR>
nmap <leader>P :FZF<CR>

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" Make fzf match the vim colorscheme colors
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" deoplete
if has('nvim')
    let g:deoplete#enable_at_startup = 1
    set completeopt-=preview
    inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ deoplete#manual_complete()
    function! s:check_back_space() abort "{{{
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~ '\s'
    endfunction"}}}
    " call deoplete#custom#option('sources', { '_': ['ale']})
endif
call deoplete#custom#source('_', 'max_menu_width', 0)

"autocmd! FileType coq let mapleader='\'
"g:coqtail_nomap = 1
" rust.vim

if ! has('nvim')
    function g:CoqtailHighlight()
        hi def CoqtailChecked ctermbg=17 guisp=bg
        hi def CoqtailSent ctermbg=6 guisp=bg
    endfunction
endif
nnoremap gt :RustTest<CR>
nnoremap gT :RustTest!<CR>

inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

" python-syntax
let g:python_highlight_all = 1
let g:python_highlight_space_errors = 0

" Language Server
" let g:LanguageClient_serverCommands = {
"     \ 'rust': ['rust-analyzer'],
"     \ }

" set completefunc=LanguageClient#complete

" unicode.vim
inoremap <C-G> <C-X><C-G>
