local lsp = require('lspconfig')
local lsp_util = require('lspconfig.util')
local protocol = require('vim.lsp.protocol')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local au = require('utils.au')
local table_merge = require('utils.misc').table_merge

local on_attach = function(autoformat)
    return function(client, bufnr)
        -- disable semantic hightlighting
        client.server_capabilities.semanticTokensProvider = nil

        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        -- Mappings
        local opts = { noremap = true, silent = true }
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)

        if client.name == "eslint" then
            buf_set_keymap('n', '<leader>f', ':EslintFixAll<CR>', opts)
            -- buf_set_keymap(
            --     'n',
            --     '<leader>f',
            --     '<Cmd>lua vim.lsp.buf.formatting_seq_sync()<CR>',
            --     opts
            -- )
        elseif client.server_capabilities.documentFormattingProvider then
            if autoformat then
                au.group('Format', function(g)
                    g.BufWritePre = {
                        '<buffer>',
                        vim.lsp.buf.format
                    }
                end)
            end
            if client.name ~= "tsserver" or client.name ~= "ts_ls" then
                buf_set_keymap(
                    'n',
                    '<leader>f',
                    '<Cmd>lua vim.lsp.buf.format()<CR>',
                    opts
                )
            end
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
    lsp.rust_analyzer.setup({
        on_attach = on_attach(config.autoformat),
        settings = config.settings,
        capabilities = capabilities,
    })

end

lsp.ts_ls.setup {
    on_attach = on_attach(false),
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    capabilities = capabilities
}
lsp.eslint.setup {
    on_attach = on_attach(true),
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    capabilities = capabilities
}
lsp.svelte.setup {
    on_attach = on_attach(true),
    capabilities = capabilities,
}
setup_rust_analyzer({
    autoformat = true,
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                autoreload = true,
                features = "all",
            },
            flags = {
                exit_timeout = 0,
            },
            checkOnSave = {
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
lsp.clangd.setup {
    on_attach = on_attach(false),
    capabilities = capabilities
}
lsp.ocamllsp.setup {
    on_attach = on_attach(true),
    capabilities = capabilities
}
lsp.elixirls.setup {
    cmd = { "/usr/bin/elixir-ls" },
    on_attach = on_attach(false),
    capabilities = capabilities
}
lsp.gopls.setup {
    on_attach = on_attach(true),
    capabilities = capabilities,
}
-- missing features
-- https://github.com/joe-re/sql-language-server/issues/173
-- https://github.com/joe-re/sql-language-server/issues/172
-- lsp.sqlls.setup {
--     on_attach = on_attach(true),
--     root_dir = lsp_util.root_pattern("docker-compose.yaml", "docker-compose.yml"),
--     capabilities = capabilities,
-- }
lsp.zls.setup {}

-- Hide all semantic highlights
-- for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
--   vim.api.nvim_set_hl(0, group, {})
-- end

-- vim.cmd [[LspStart]]

