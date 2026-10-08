local prev = vim.wo.listchars
vim.cmd('setlocal listchars=tab:\\ \\ ')

local undo = vim.b.undo_ftplugin
vim.b.undo_ftplugin = (undo and undo .. ' | ' or '')
    .. 'let &l:listchars = '
    .. vim.fn.string(prev)
