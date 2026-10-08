local prev = vim.wo.conceallevel
vim.opt_local.conceallevel = 0

local undo = vim.b.undo_ftplugin
vim.b.undo_ftplugin = (undo and undo .. ' | ' or '')
    .. 'let &l:conceallevel = '
    .. vim.fn.string(prev)
