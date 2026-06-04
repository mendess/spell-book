local command = require('utils.command')

-- no help
vim.keymap.set('n', '<F1>', ':echo<CR>')
vim.keymap.set('i', '<F1>', '<C-o>:echo<CR>')

-- clear selection
vim.keymap.set('n', '<leader><leader>', ':noh<CR>', { noremap = true })

-- Ctrl+C and Ctrl+X
vim.keymap.set('v', '<C-c>', '"+y', { noremap = true })
vim.keymap.set('v', '<C-x>', '"+d', { noremap = true })

-- fast replace
vim.keymap.set('n', 'S', [[:%s/\<<C-r><C-w>\>/]], { noremap = true })

-- nerdtree
vim.keymap.set('n', '\\', ':Neotree toggle<CR>', { noremap = true })

-- gitgutter
vim.keymap.set('n', '<leader>g', ':GitGutterToggle<CR>', { noremap = true })
command.Gd = ':GitGutterPreviewHunk'
command.Gco = ':GitGutterUndoHunk'

-- telescope
vim.keymap.set('n', '<leader>p', function() require('telescope.builtin').find_files() end, { silent = true, noremap = true })
vim.keymap.set('n', '<leader>b', function() require('telescope.builtin').buffers() end, { silent = true, noremap = true })
vim.keymap.set('n', 'gD', function() require('telescope.builtin').lsp_type_definitions() end, { silent = true, noremap = true })
vim.keymap.set('n', '<leader>l', function() require('telescope.builtin').live_grep() end, { silent = true, noremap = true })

-- windowing
vim.keymap.set('n', '<c-w>o', ':tab split<CR>', { noremap = true })
vim.keymap.set('n', '<c-w>o <c-w>', ':tab split<CR>', { noremap = true })

-- show/hide tab
vim.keymap.set('n', '<leader>,', ':set invlist<CR>', { noremap = true })

-- bookmarks

vim.keymap.set({ "n", "v" }, "mm", "<cmd>BookmarksMark<cr>", { desc = "Mark current line into active BookmarkList." })
vim.keymap.set({ "n", "v" }, "mo", "<cmd>BookmarksGoto<cr>", { desc = "Go to bookmark at current active BookmarkList" })
vim.keymap.set({ "n", "v" }, "ma", "<cmd>BookmarksCommands<cr>", { desc = "Find and trigger a bookmark command." })
vim.keymap.set("n"         , "mt", "<cmd>BookmarksTree<cr>", { desc = "Open the bookmarks tree view" })
