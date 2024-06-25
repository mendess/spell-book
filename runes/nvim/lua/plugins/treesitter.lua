require('nvim-treesitter.configs').setup({
    ensure_installed = { "lua", "vim", "vimdoc", "markdown", "markdown_inline" },

    sync_install = false,
    auto_install = false,
    highlight = {
        enable = false,
    }
})
