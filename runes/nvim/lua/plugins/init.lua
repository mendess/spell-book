local gh = function(x)
    return 'https://github.com/' .. x
end

local plugin_configs = {}
local plugins_dir = vim.fn.stdpath('config') .. '/lua/plugins'

for name in vim.fs.dir(plugins_dir) do
    if name ~= 'init.lua' and vim.endswith(name, '.lua') then
        local stat = vim.uv.fs_stat(vim.fs.joinpath(plugins_dir, name))
        if stat and stat.type == 'file' then
            plugin_configs[#plugin_configs + 1] = name:sub(1, -5)
        end
    end
end

table.sort(plugin_configs)

for index, name in ipairs(plugin_configs) do
    plugin_configs[index] = require('plugins.' .. name)
end

local function configure_plugins(stage)
    for _, config in ipairs(plugin_configs) do
        if config[stage] then
            local ok, err = pcall(config[stage])
            if not ok then
                vim.notify(stage .. ': ' .. err, vim.log.levels.WARN)
            end
        end
    end
end

configure_plugins('before')

vim.pack.add({
    gh('rebelot/kanagawa.nvim'),

    -- basic improvements
    gh('godlygeek/tabular'),
    gh('tpope/vim-repeat'),

    -- git integration
    gh('tpope/vim-fugitive'),
    gh('shumphrey/fugitive-gitlab.vim'),
    gh('tpope/vim-rhubarb'),

    -- syntax
    gh('waycrate/swhkd-vim'),
    gh('cstrahan/vim-capnp'),
    gh('chrisbra/csv.vim'),

    -- ide
    gh('rafamadriz/friendly-snippets'),
    gh('nvim-mini/mini.nvim'),
    {
        src = gh('nvim-treesitter/nvim-treesitter'),
        version = 'main',
    },
    gh('mason-org/mason.nvim'),
    gh('creativenull/efmls-configs-nvim'),
    gh('neovim/nvim-lspconfig'),

    -- floating terminal
    gh('ingur/floatty.nvim'),
})

configure_plugins('after')
