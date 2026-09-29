return {
    after = function()
        require('nvim-treesitter-textobjects').setup({
            select = {
                enable = true,
                lookahead = true,
            },
        })
    end,
}
