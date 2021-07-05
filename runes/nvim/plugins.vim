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

Plug 'junegunn/fzf.vim'

if work_pc
    " Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/nvim-compe'
else
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
endif

if ! has('nvim')
    Plug 'whonore/Coqtail'
    Plug 'let-def/vimbufsync'
endif

" Plug 'Shougo/echodoc.vim'

Plug 'rust-lang/rust.vim'

" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }

Plug 'godlygeek/tabular'

Plug 'chrisbra/unicode.vim'

Plug 'chrisbra/csv.vim'

Plug 'airblade/vim-gitgutter'

call plug#end()

""" PLUGIN CONFIGS

" Ayu config
set termguicolors
let base16colorspace=256  " Access colors present in 256 colorspace
let ayucolor="dark"
"colorscheme ayu
colorscheme base16-default-dark

function! s:base16_customize() abort
    call Base16hi("MatchParen", "", "", "", "", "bold", "")
    call Base16hi("Comment", g:base16_gui04, "", g:base16_cterm04, "", "", "")
endfunction

function CommentsWhite()
    call Base16hi("Comment", g:base16_gui04, "", g:base16_cterm04, "", "", "")
endfunction
function CommentsBrown()
    call Base16hi("Comment", g:base16_gui0F, "", g:base16_cterm0F, "", "", "")
endfunction

augroup on_change_colorschema
    autocmd!
    autocmd ColorScheme * call s:base16_customize()
augroup END

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
if work_pc

    " " Use tab for trigger completion with characters ahead and navigate.
    " " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " " other plugin before putting this into your config.
    " inoremap <silent><expr> <TAB>
    "             \ pumvisible() ? "\<C-n>" :
    "             \ <SID>check_back_space() ? "\<TAB>" :
    "             \ coc#refresh()
    " inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    " function! s:check_back_space() abort
    "     let col = col('.') - 1
    "     return !col || getline('.')[col - 1]  =~# '\s'
    " endfunction

    " " Use <c-space> to trigger completion.
    " if has('nvim')
    "     inoremap <silent><expr> <c-space> coc#refresh()
    " else
    "     inoremap <silent><expr> <c-@> coc#refresh()
    " endif

    " " Make <CR> auto-select the first completion item and notify coc.nvim to
    " " format on enter, <cr> could be remapped by other vim plugin
    " inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
    "             \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    " " Use `[g` and `]g` to navigate diagnostics
    " " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
    " nmap <silent> <F10> <Plug>(coc-diagnostic-prev)
    " nmap <silent> <F12> <Plug>(coc-diagnostic-next)

    " " GoTo code navigation.
    " nmap <silent> gd <Plug>(coc-definition)
    " nmap <silent> gy <Plug>(coc-type-definition)
    " nmap <silent> gi <Plug>(coc-implementation)
    " nmap <silent> gr <Plug>(coc-references)
    " nmap <silent> <A-Enter> :CocFix<CR>

    " " Use K to show documentation in preview window.
    " au FileType c,sh nnoremap K :Man<CR>
    " nnoremap <silent> K :call <SID>show_documentation()<CR>

    " function! s:show_documentation()
    "     if (index(['vim','help'], &filetype) >= 0)
    "         execute 'h '.expand('<cword>')
    "     elseif (coc#rpc#ready())
    "         call CocActionAsync('doHover')
    "     else
    "         execute '!' . &keywordprg . " " . expand('<cword>')
    "     endif
    " endfunction

    " " Highlight the symbol and its references when holding the cursor.
    " autocmd CursorHold * silent call CocActionAsync('highlight')

    " " Symbol renaming.
    " nmap <leader>c <Plug>(coc-rename)

    " java
    " let $JAVA_TOOL_OPTIONS = '-javaagent:/home/mendess/.m2/repository/org/projectlombok/lombok/1.18.20/lombok-1.18.20.jar -Xbootclasspath/p:/home/mendess/.m2/repository/org/projectlombok/lombok/1.18.20/lombok-1.18.20.jar'

    lua <<EOF
    local nvim_lsp = require('lspconfig')

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        --Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { noremap=true, silent=true }

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
        buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<space>c', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', '<space>x', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
        buf_set_keymap('n', '<F10>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', '<F12>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

    end

    -- Use a loop to conveniently call 'setup' on multiple servers and
    -- map buffer local keybindings when the language server attaches
    local servers = { "rust_analyzer", "tsserver" }
    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
            on_attach = on_attach,
            flags = {
                debounce_text_changes = 150,
                }
            }
    end

EOF
set completeopt=menuone,noselect
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.resolve_timeout = 800
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:true
let g:compe.source.luasnip = v:true
let g:compe.source.emoji = v:true

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

lua <<EOF
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif vim.fn['vsnip#available'](1) == 1 then
    return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  elseif vim.fn['vsnip#jumpable'](-1) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
EOF
else
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
    let g:ale_cpp_cc_options = '-std=c++2a -Wall -pedantic'
    let g:ale_c_clangtidy_options = '-x c'
    let g:ale_c_parse_compile_commands = 1
    let g:ale_c_parse_makefile = 1
    let g:ale_rust_cargo_check_tests = 1
    let g:ale_rust_cargo_default_feature_behavior = 'all'
    let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
    " this doesn't work
    let g:ale_rust_analyzer_config = {
                \ 'rust': {
                    \   'clippy_preference': 'on',
                    \   'procMacro': { 'enable': v:true },
                    \ },
                    \ 'procMacro': { 'enable': v:true },
                    \ 'cargo': { 'loadOutDirsFromCheck': v:true },
                    \ }

    au FileType c,sh nnoremap K :Man<CR>
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
        else
            execute :ALEHover
        endif
    endfunction
    " Autoformat
    map <leader>f :Neoformat<CR>
    let g:shfmt_opt="-ci"
    let g:rustfmt_opt="--edition 2018"
    let g:neoformat_rust_rustfmt = {
                \ 'exe': 'rustfmt',
                \ 'args': [
                    \ '--edition', '2018',
                    \ '--config', 'hard_tabs=false,tab_spaces=4,max_width=99'
                    \],
                    \ 'stdin': 1,
                    \ }
    let g:neoformat_python_yapf = {
                \ 'exe': 'yapf',
                \ 'args': ['--style="{based_on_style: pep8, dedent_closing_brackets: True}"'],
                \ 'stdin': 1,
                \ }
    let g:neoformat_enabled_python = ['yapf']
endif



" FZF
nmap <leader>p :GFiles --exclude-standard --others --cached<CR>
nmap <leader>P :Buffers<CR>

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
if work_pc
else
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
nnoremap <leader>t :RustTest<CR>
nnoremap <leader>T :RustTest!<CR>

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

" gitgutter
nnoremap <leader>g :GitGutterToggle<CR>
command! Gd :GitGutterPreviewHunk
command! Gco :GitGutterUndoHunk
let g:gitgutter_enabled = 0

"echodoc

set noshowmode
let g:echodoc#enable_at_startup = 1
