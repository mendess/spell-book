return {
    after = function()
        require('aerial').setup({})
        vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle!<CR>')
    end,
}
