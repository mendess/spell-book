local lsp = require('lspconfig')
local protocol = require('vim.lsp.protocol')
local update_capabilities = require('cmp_nvim_lsp').update_capabilities
local au = require('utils.au')

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Mappings
    local opts = { noremap = true, silent = true }
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    if client.resolved_capabilities.document_formatting then
        au.group('Format', function(g)
            g.BufWritePre = {
                '<buffer>',
                vim.lsp.buf.formatting_seq_sync
            }
        end)
    end
end

lsp.tsserver.setup {
    on_attach = on_attach,
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    capabilities = update_capabilities(protocol.make_client_capabilities())
}
lsp.rust_analyzer.setup {
    on_attach = on_attach,
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
    capabilities = update_capabilities(protocol.make_client_capabilities())
}
lsp.bashls.setup {
    on_attach = on_attach,
    capabilities = update_capabilities(protocol.make_client_capabilities())
}
lsp.clangd.setup {
    on_attach = on_attach,
    capabilities = update_capabilities(protocol.make_client_capabilities())
}

vim.cmd [[LspStart]]
