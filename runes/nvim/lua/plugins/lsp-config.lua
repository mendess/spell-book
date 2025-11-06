local lsp_util = require('lspconfig.util')
local protocol = require('vim.lsp.protocol')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local au = require('utils.au')
local table_merge = require('utils.misc').table_merge

local on_attach = function(opts)
    opts = setmetatable(opts or {}, {__index = { format_on_save=true }})
    return function(client, bufnr)
        -- disable semantic hightlighting
        -- client.server_capabilities.semanticTokensProvider = nil

        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        local keybind_opts = { noremap = true, silent = true }
        -- Mappings
        buf_set_keymap(
            'n',
            'gd',
            '<Cmd>lua vim.lsp.buf.definition()<CR>',
            keybind_opts
        )

        -- prefer eslint format instead of this
        local is_ts_ls = client.name == "ts_ls"

        -- local function log(...) print("[" .. client.name .. "]", ...) end

        -- the eslint linter doesn't provide lsp formatting capabilities but
        -- provides a vim command for formatting...
        -- if client.name == "eslint" then
        --     buf_set_keymap('n', '<leader>f', ':LspEslintFixAll<CR>', keybind_opts)
        --     if opts.format_on_save then
        --         au.group('Format', function(g)
        --             g.BufWritePre = { '<buffer>', ':LspEslintFixAll' }
        --         end)
        --     end
        if client.server_capabilities.documentFormattingProvider then
            if opts.format_on_save then
                au.group('Format', function(g)
                    g.BufWritePre = { '<buffer>', vim.lsp.buf.format }
                end)
            end
            buf_set_keymap(
                'n',
                '<leader>f',
                '<Cmd>lua vim.lsp.buf.format()<CR>',
                keybind_opts
            )
        end
    end
end


local function setup_rust_analyzer(config)
    -- Function to load settings from the .nvim/settings.json file
    local load_project_settings = function()
        local rust_project_root = lsp_util.root_pattern("Cargo.toml")(vim.fn.getcwd())
        if rust_project_root == nil then
            return nil
        end
        local settings_file = rust_project_root .. '/.nvim/settings.json'
        if vim.fn.filereadable(settings_file) == 1 then
            local file = io.open(settings_file, "r")
            local content = file:read("*a")
            file:close()
            local settings = vim.fn.json_decode(content)
            return settings
        else
            return nil
        end
    end

    -- Check if Cargo.toml exists
    local local_overrides = load_project_settings()
    if local_overrides then
        -- Load project-specific settings
        config.settings = table_merge(config.settings, local_overrides)
    end
    vim.lsp.config("rust_analyzer", {
        on_attach = on_attach({ format_on_save = config.format_on_save }),
        settings = config.settings,
        capabilities = capabilities,
    })
    vim.lsp.enable("rust_analyzer")

end

vim.lsp.config("ts_ls", {
    on_attach = on_attach({ format_on_save = false }),
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    capabilities = capabilities
})
vim.lsp.enable("ts_ls")
vim.lsp.config("eslint", {
    on_attach = on_attach(),
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    capabilities = capabilities
})
vim.lsp.enable("eslint")
setup_rust_analyzer({
    format_on_save = true,
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                autoreload = true,
            },
            flags = {
                exit_timeout = 0,
            },
            checkOnSave = true,
            check = {
                command = "clippy",
            },
            procMacro = {
                enable = true,
            },
            imports = {
                group = {
                    enable = false,
                },
            },
        },
    }
})
-- lsp.bashls.setup {
--     on_attach = on_attach(true),
--     capabilities = update_capabilities(protocol.make_client_capabilities())
-- }
vim.lsp.config("clangd", {
    on_attach = on_attach({ format_on_save = false }),
    capabilities = capabilities
})
vim.lsp.enable("clangd")
vim.lsp.config("gopls", {
    on_attach = on_attach(),
    capabilities = capabilities,
})
vim.lsp.enable("gopls")
-- missing features
-- https://github.com/joe-re/sql-language-server/issues/173
-- https://github.com/joe-re/sql-language-server/issues/172
-- lsp.sqlls.setup {
--     on_attach = on_attach(true),
--     root_dir = lsp_util.root_pattern("docker-compose.yaml", "docker-compose.yml"),
--     capabilities = capabilities,
-- }
vim.lsp.enable("zls")

-- Hide all semantic highlights
-- for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
--   vim.api.nvim_set_hl(0, group, {})
-- end

-- vim.cmd [[LspStart]]

