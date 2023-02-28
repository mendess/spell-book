local lsp = require('lspconfig')
local protocol = require('vim.lsp.protocol')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local au = require('utils.au')

function print_table(t)

    local function printTableHelper(obj, cnt)
        local cnt = cnt or 0
        local s = ""
        if type(obj) == "table" then
            s = s .. "\n" .. string.rep("\t", cnt) .. "{\n"
            cnt = cnt + 1
            for k,v in pairs(obj) do
                if type(k) == "string" then
                    s = s .. string.rep("\t",cnt) .. '["'..k..'"]' .. ' = '
                elseif type(k) == "number" then
                    s = s .. string.rep("\t",cnt) .. "["..k.."]" .. " = "
                end
                s = s .. printTableHelper(v, cnt) .. ",\n"
            end
            cnt = cnt-1
            s = s .. string.rep("\t", cnt) .. "}"

        elseif type(obj) == "string" then
            s = s .. string.format("%q", obj)
        else
            s = s .. tostring(obj)
        end
        return s
    end

    return printTableHelper(t)
end

function dbg(x)
    file = io.open('dbg', 'a')
    if type(x) == "table" then
        file:write(print_table(x))
    else
        file:write(tostring(x).."\n")
    end
    return x
end

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
            if client.name ~= "tsserver" then
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

lsp.tsserver.setup {
    on_attach = on_attach(false),
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    capabilities = capabilities
}
lsp.eslint.setup {
    on_attach = on_attach(true),
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    capabilities = capabilities
}
lsp.rust_analyzer.setup {
    on_attach = on_attach(true),
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                autoreload = true
            },
            flags = {
                exit_timeout = 0,
            },
            checkOnSave = {
                command = "clippy"
            },
        }
    },
    capabilities = capabilities
}
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

vim.cmd [[LspStart]]
