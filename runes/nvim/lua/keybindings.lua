local command = require('utils.command')

-- no help
nmap('<F1>', ':echo<CR>')
imap('<F1>', '<C-o>:echo<CR>')

-- clear selection
nnoremap('<leader><leader>', ':noh<CR>')

-- Ctrl+C and Ctrl+X
vnoremap('<C-c>', '"+y')
vnoremap('<C-x>', '"+d')

-- fast replace
nnoremap('s', ':%s//<Left>')
nnoremap('S', [[:%s/\<<C-r><C-w>\>/]])
vnoremap('s', ':s//<Left>')

-- nerdtree
nnoremap('<F2>', ':NERDTreeToggle<CR>')
inoremap('<F2>', ':NERDTreeToggle<CR>')

-- gitgutter
nnoremap('<leader>g', ':GitGutterToggle<CR>')
command.Gd = ':GitGutterPreviewHunk'
command.Gco = ':GitGutterUndoHunk'
