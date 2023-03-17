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
nnoremap('<F2>', ':Neotree toggle<CR>')
nnoremap('\\', ':Neotree toggle<CR>')
inoremap('<F2>', ':Neotree toggle<CR>')

-- gitgutter
nnoremap('<leader>g', ':GitGutterToggle<CR>')
command.Gd = ':GitGutterPreviewHunk'
command.Gco = ':GitGutterUndoHunk'

-- telescope
mapx.group({ silent = true }, function()
    nnoremap('<leader>p', function() require('telescope.builtin').find_files() end)
    nnoremap('<leader>b', function() require('telescope.builtin').buffers() end)
    command.Rg = function() require('telescope.builtin').grep_string() end
end)

-- windowing
nnoremap('<c-w>o', ':tab split<CR>')
tnoremap('<c-w>o <c-w>', ':tab split<CR>')
