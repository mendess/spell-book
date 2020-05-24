if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'salsifis/vim-transpose'

" Color scheme
Plug 'Mendess2526/ayu-vim'
Plug 'chriskempson/base16-vim'

" File browser
Plug 'scrooloose/nerdtree'

" Auto close parens
"Plug 'cohama/lexima.vim'
Plug 'jiangmiao/auto-pairs'

Plug 'bitc/vim-bad-whitespace'

Plug 'tpope/vim-surround'

Plug 'tpope/vim-commentary'

Plug 'tpope/vim-repeat'

Plug 'tpope/vim-abolish'

Plug 'machakann/vim-highlightedyank'

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
Plug 'JuliaEditorSupport/julia-vim'

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

call plug#end()

""" PLUGIN CONFIGS

" Ayu config
set termguicolors
let base16colorspace=256  " Access colors present in 256 colorspace
let ayucolor="dark"
"colorscheme ayu
colorscheme base16-default-dark

if has('nvim')
    command! Bt :highlight Normal ctermbg=None | :highlight Normal guibg=None
else
    command! Bt :highlight Normal ctermbg=NONE | :highlight Normal guibg=NONE
endif
command! Bo :colorscheme base16-default-dark

" Nerdtree config
map <F2> :NERDTreeToggle<CR>
imap <F2> :NERDTreeToggle<CR>
let NERDTreeSortOrder=['include/$', 'src/$']

" highlightedyank
let g:highlightedyank_highlight_duration = 100

" " vim-commentary
" autocmd FileType coq setlocal commentstring=(*\ %s\ *)
" autocmd FileType sxhkdrc setlocal commentstring=#\ %s

" function! s:goyo_leave()
"     :set number relativenumber
"     :augroup numbertoggle
"     :  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"     :  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
"     :augroup END
"     :highlight ColorColumn ctermbg=Black
"     :set colorcolumn=101
"     :highlight Normal ctermbg=None
" endfunction

" autocmd! User GoyoEnter nested call <SID>goyo_enter()
" autocmd! User GoyoLeave nested call <SID>goyo_leave()
" let g:goyo_height='90'
" let g:goyo_width='83'

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
let g:ale_cpp_clangtidy_options = '-std=c++2a'
let g:ale_linters = { 'rust' : ['rls'] , 'c': ['ccls', 'clangtidy', 'clangcheck'], 'cpp': ['ccls','g++','clangtidy','clang++']}
let g:ale_fixers = { 'rust': ['rustfmt'] }
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
" augroup fmt
"   autocmd!
"   autocmd BufWritePre *.c Neoformat
"   autocmd BufWritePre *.h Neoformat
"   autocmd BufWritePre *.cpp Neoformat
"   autocmd BufWritePre *.hpp Neoformat
" augroup END

" FZZ
nmap <leader>p :FZF<CR>
nmap <leader>P :FZF<CR>

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
