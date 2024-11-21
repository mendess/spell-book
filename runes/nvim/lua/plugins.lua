local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

return require('lazy').setup({
    ------ ======      META       ====== ------
    -- mappings api
    'b0o/mapx.nvim',
    -- profiling
    {'tweekmonster/startuptime.vim', enabled = false },
    ------ ============================= ------

    ------ ======  COLOR SCHEMES  ====== ------
    'mendess/nvim-base16.lua',
    'mendess/ayu-vim',
    'sainnhe/everforest',
    'rebelot/kanagawa.nvim',
    ------ ============================= ------


    ------ ====== EXTRA KEYBINDS  ====== ------
    -- quick quoting/unquoting/swap quoting keybinds
    'tpope/vim-surround',
    -- quick comment keybind
    'tpope/vim-commentary',
    ------ ============================= ------


    ------ ======     INSIGHT     ====== ------
    -- File browser
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = "v2.x",
        dependencies = {
            'nvim-lua/plenary.nvim',
            'MunifTanjim/nui.nvim'
        },
        init = function()
            vim.g.neo_tree_remove_legacy_commands = 1
        end,
        opts = {
            close_if_last_window = true,
            default_component_configs = {
                icon = {
                    folder_closed = "▶️",
                    folder_open = "v",
                    folder_empty = "▶️",
                    default = " ",
                },
                name = {
                    trailing_slash = true,
                },
                git_status = {
                    symbols = {
                        modified = "M",
                        untracked = "",
                        ignored = "I",
                        unstaged = "U",
                        staged = "S",
                        conflict = "C",
                    },
                },
            },
            filesystem = {
                follow_current_file = true,
            },
            buffers = {
                follow_current_file = true,
            },
        }
    },
    -- git keybinds
    {
        'airblade/vim-gitgutter',
        config = function() vim.g.gitgutter_enabled = 0 end,
    },
    { 'tpope/vim-fugitive' },
    {
        'shumphrey/fugitive-gitlab.vim',
        config = function() vim.g.fugitive_gitlab_domains = {'https://gitlab.cfdata.org'} end,
        dependencies = { 'tpope/vim-fugitive' },
    },
    {
        'tpope/vim-rhubarb',
        dependencies = { 'tpope/vim-fugitive' },
    },
    -- detect bad whitespace
    {
        'ntpeters/vim-better-whitespace',
        init = function()
            vim.g.better_whitespace_enabled = false
            vim.g.better_whitespace_filetypes_blacklist={
                'neo-tree', 'diff', 'git', 'gitcommit', 'unite', 'qf', 'help', 'markdown', 'fugitive'
            }
        end,
    },
    -- highlight select text for a bit
    {
        'machakann/vim-highlightedyank',
        init = function() vim.g.highlightedyank_highlight_duration = 100 end
    },
    'tversteeg/registers.nvim',
    ------ ============================= ------


    ------ ====== QUALITY OF LIFE ====== ------
    -- auto close delimiters
    'cohama/lexima.vim',
    -- auto close html tags
    'alvan/vim-closetag',
    -- better .
    'tpope/vim-repeat',
    -- make vim understand tables
    'godlygeek/tabular',
    ------ ============================= ------


    ------ ======       IDE       ====== ------
    -- language server
    {
        'neovim/nvim-lspconfig',
        dependencies = {'nvim-cmp'},
        event = "InsertEnter",
        config = function() require('plugins.lsp-config') end,
    },
    -- syntax highlighting
    {
        'sheerun/vim-polyglot',
        init = function()
            vim.g.polyglot_disabled = {'sensible', 'autoindent'}
        end,
    },

    'evanleck/vim-svelte',

    'waycrate/swhkd-vim',

    'cstrahan/vim-capnp',

    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require('plugins.treesitter')
        end,
    },
    -- pweatty lsp frontend
    {
        'nvimdev/lspsaga.nvim',
        dependencies = {"nvim-lspconfig"},
        config = function() require('plugins.lspsaga') end,
    },
    -- completion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/vim-vsnip',
            {'hrsh7th/cmp-vsnip', dependencies = {'vim-vsnip'} },
            'hrsh7th/cmp-emoji',
        },
        config = function() require('plugins.cmp') end,
        event = "VimEnter *"
    },
    -- fuzzy finder
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
        },
        config = function() require('plugins.telescope') end,
        module = {'telescope', 'telescope.builtin'},
    },
    ------ ============================= ------

    ------ ======  EXTRA SINTAX   ====== ------
    -- Rust
    {
        'rust-lang/rust.vim',
        ft = { 'rust' }
    },
    {
        'lukas-reineke/headlines.nvim',
        config = function()
            require('headlines').setup()
        end,
        enabled = false,
    },
    {
        'fatih/vim-go',
        init = function()
            vim.g.go_fmt_autosave = 0
            vim.g.go_fmt_fail_silently = 0
            vim.g.go_mod_fmt_autosave = 0

            vim.g.go_gopls_enabled = 0
            vim.g.go_def_mapping_enabled = 0
            vim.g.go_code_completion_enabled = 0
            vim.g.go_doc_keywordprg_enabled = 0

            vim.g.go_highlight_types = 1
            vim.g.go_highlight_fields = 1
            vim.g.go_highlight_functions = 1
            vim.g.go_highlight_function_calls = 1
            vim.g.go_highlight_function_calls = 1
            vim.g.go_highlight_operators = 1
            vim.g.go_highlight_extra_types = 1
            vim.g.go_highlight_build_constraints = 1
        end,
    },
    ------ ============================= ------
}, {
    lazy = true,
})
