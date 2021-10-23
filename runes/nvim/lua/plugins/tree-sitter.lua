require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
        disable = {},
    },
    indent = {
        enable = false,
        disable = {},
    },
    ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "css",
        "glsl",
        "html",
        "javascript",
        "json",
        "kotlin",
        "latex",
        "lua",
        "python",
        "regex",
        -- "rust",
        "scss",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "yaml"
    }
}
