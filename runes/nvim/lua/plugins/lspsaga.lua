local saga = require('lspsaga')

saga.setup({
    ui = {
        code_action_icon = "",
    },
    symbol_in_winbar = { enable = false },
    lightbulb = { enable = false },
})

mapx.group({ silent = true }, function()
    nnoremap('K', ':Lspsaga hover_doc<CR>')
    -- inoremap('<C-j>', signature_help)
    nnoremap('gh', ':Lspsaga finder<CR>')
    nnoremap('[e', ':Lspsaga diagnostic_jump_prev<CR>')
    nnoremap(']e', ':Lspsaga diagnostic_jump_next<CR>')
    nnoremap('<leader>c', ':Lspsaga rename<CR>')
    nnoremap('<A-Return>', ':Lspsaga code_action<CR>')
end)
