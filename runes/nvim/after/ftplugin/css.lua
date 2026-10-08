local tabstop = vim.bo.tabstop
local shiftwidth = vim.bo.shiftwidth
local softtabstop = vim.bo.softtabstop

vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2

local undo = vim.b.undo_ftplugin
vim.b.undo_ftplugin = (undo and undo .. ' | ' or '')
    .. string.format(
        'setlocal tabstop=%d shiftwidth=%d softtabstop=%d',
        tabstop,
        shiftwidth,
        softtabstop
    )
