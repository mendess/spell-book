local saga = require('lspsaga')

saga.setup({
    ui = {
        code_action_icon = "",
    },
    symbol_in_winbar = { enable = false },
    lightbulb = { enable = false },
})

vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>')
vim.keymap.set('n', 'gh', '<cmd>Lspsaga finder<CR>')
vim.keymap.set('n', '[e', '<cmd>Lspsaga diagnostic_jump_prev<CR>')
vim.keymap.set('n', ']e', '<cmd>Lspsaga diagnostic_jump_next<CR>')
vim.keymap.set('n', '<leader>c', '<cmd>Lspsaga rename<CR>')
vim.keymap.set('n', '<A-Return>', '<cmd>Lspsaga code_action<CR>')
