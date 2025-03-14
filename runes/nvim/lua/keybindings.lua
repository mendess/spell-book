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
nnoremap('S', [[:%s/\<<C-r><C-w>\>/]])

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
    nnoremap('gD', function() require('telescope.builtin').lsp_type_definitions() end)
    nnoremap('<leader>l', function() require('telescope.builtin').live_grep() end)
end)

-- windowing
nnoremap('<c-w>o', ':tab split<CR>')
tnoremap('<c-w>o <c-w>', ':tab split<CR>')

-- show/hide tab
nnoremap('<leader>,', ':set invlist<CR>')

-- bookmarks

vim.keymap.set({ "n", "v" }, "mm", "<cmd>BookmarksMark<cr>", { desc = "Mark current line into active BookmarkList." })
vim.keymap.set({ "n", "v" }, "mo", "<cmd>BookmarksGoto<cr>", { desc = "Go to bookmark at current active BookmarkList" })
vim.keymap.set({ "n", "v" }, "ma", "<cmd>BookmarksCommands<cr>", { desc = "Find and trigger a bookmark command." })
vim.keymap.set("n"         , "mt", "<cmd>BookmarksTree<cr>", { desc = "Open the bookmarks tree view" })
