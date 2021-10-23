local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]

return require('packer').startup({function(use)
    ------ ======      META       ====== ------
    -- manager manages itself
    use 'wbthomason/packer.nvim'
    -- mappings api
    use 'b0o/mapx.nvim'
    ------ ============================= ------


    ------ ======  COLOR SCHEMES  ====== ------
    use 'chriskempson/base16-vim'
    use 'mendess/ayu-vim'
    use 'ntk148v/vim-horizon'
    ------ ============================= ------


    ------ ====== EXTRA KEYBINDS  ====== ------
    -- quick quoting/unquoting/swap quoting keybinds
    use 'tpope/vim-surround'
    -- quick comment keybind
    use 'tpope/vim-commentary'
    ------ ============================= ------


    ------ ======     INSIGHT     ====== ------
    -- File browser
    use {
        'scrooloose/nerdtree',
        config = function() vim.g.NERDTreeSortOrder = {'include/$', 'src/$'} end
    }
    -- git keybinds
    use {
        'airblade/vim-gitgutter',
        config = function() vim.g.gitgutter_enabled = 0 end,
    }
    -- detect bad whitespace
    use 'bitc/vim-bad-whitespace'
    -- highlight select text for a bit
    use {
        'machakann/vim-highlightedyank',
        config = function() vim.g.highlightedyank_highlight_duration = 100 end
    }
    ------ ============================= ------


    ------ ====== QUALITY OF LIFE ====== ------
    -- auto close delimiters
    use 'cohama/lexima.vim'
    -- auto close html tags
    use 'alvan/vim-closetag'
    -- better .
    use 'tpope/vim-repeat'
    -- helpfull prompt with keybinds
    use {
        'folke/which-key.nvim',
        config = function() require('plugins.which-key') end,
    }
    -- make vim understand tables
    use 'godlygeek/tabular'
    ------ ============================= ------


    ------ ======       IDE       ====== ------
    -- language server
    use {
        'neovim/nvim-lspconfig',
        after = 'nvim-cmp',
        config = function() require('plugins.lsp-config') end,
    }
    -- smart syntax highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function() require('plugins.tree-sitter') end,
    }
    -- pweatty lsp frontend
    use {
        'tami5/lspsaga.nvim',
        branch = "nvim51",
        config = function() require('plugins.lspsaga') end,
    }
    -- completion
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/vim-vsnip',
            'hrsh7th/cmp-vsnip',
        },
        config = function() require('plugins.cmp') end,
    }
    -- fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
        },
        config = function() require('plugins.telescope') end,
    }
    ------ ============================= ------

    ------ ======      OTHER      ====== ------
    -- Rust
    use 'rust-lang/rust.vim'
    ------ ============================= ------
end,
config = {
    display = {
        open_fn = require('packer.util').float
    }
}})

-- Plug('chrisbra/unicode.vim')

-- Plug('chrisbra/csv.vim')

-- Plug('sheerun/vim-polyglot')
