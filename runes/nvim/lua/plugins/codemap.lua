return {
    after = function()
        require('codemap.init').setup({})
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'codemap',
            callback = function(args)
                vim.keymap.set(
                    'n',
                    'q',
                    '<cmd>CodemapClose<cr>',
                    { buffer = args.buf, nowait = true }
                )
            end,
        })
    end,
}
