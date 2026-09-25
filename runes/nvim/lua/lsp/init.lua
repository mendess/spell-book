local group = vim.api.nvim_create_augroup('user-lsp', { clear = true })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend(
    'force',
    capabilities,
    require('mini.completion').get_lsp_capabilities()
)

vim.lsp.config('*', { capabilities = capabilities })
do
    local rustfmt = require('efmls-configs.formatters.rustfmt')

    local stylua = require('efmls-configs.formatters.stylua')

    local black = require('efmls-configs.formatters.black')

    local prettier_d = require('efmls-configs.formatters.prettier_d')
    local eslint_d = require('efmls-configs.linters.eslint_d')
    local oxlint = require('efmls-configs.linters.oxlint')
    local oxfmt = require('efmls-configs.formatters.oxfmt')

    local fixjson = require('efmls-configs.formatters.fixjson')

    local shellcheck = require('efmls-configs.linters.shellcheck')
    local shfmt = require('efmls-configs.formatters.shfmt')
    -- format with spaces
    shfmt.formatCommand = shfmt.formatCommand:gsub('%s+%-$', ' -i 4 -')

    local cpplint = require('efmls-configs.linters.cpplint')
    local clangfmt = require('efmls-configs.formatters.clang_format')

    local go_revive = require('efmls-configs.linters.go_revive')
    local gofumpt = require('efmls-configs.formatters.gofumpt')

    vim.lsp.config('efm', {
        filetypes = {
            'c',
            'cpp',
            'css',
            'rust',
            'go',
            'html',
            'javascript',
            'json',
            'jsonc',
            'lua',
            'markdown',
            'python',
            'sh',
            'typescript',
        },
        init_options = { documentFormatting = true },
        settings = {
            languages = {
                c = { clangfmt, cpplint },
                go = { gofumpt, go_revive },
                cpp = { clangfmt, cpplint },
                css = { prettier_d },
                html = { prettier_d },
                javascript = { oxlint, oxfmt, eslint_d, prettier_d },
                json = { eslint_d, fixjson },
                jsonc = { eslint_d, fixjson },
                lua = { stylua },
                markdown = { prettier_d },
                python = { black },
                sh = { shellcheck, shfmt },
                typescript = { oxlint, oxfmt, eslint_d, prettier_d },
                rust = { rustfmt },
            },
        },
    })
end

vim.api.nvim_create_autocmd('BufWritePre', {
    desc = 'Format on save',
    group = group,
    callback = function(ev)
        local efm = vim.lsp.get_clients({
            name = 'efm',
            bufnr = ev.buf,
        })

        if vim.tbl_isempty(efm) then
            return
        end

        local view = vim.fn.winsaveview()

        vim.lsp.buf.format({
            name = 'efm',
            bufnr = ev.buf,
        })

        vim.fn.winrestview(view)
    end,
})

vim.lsp.config('ts_ls', {})
vim.lsp.config('pyright', {})
vim.lsp.config('clangd', {})
vim.lsp.config('gopls', {})
vim.lsp.config('zls', {})
vim.lsp.config('pyright', {})
vim.lsp.config('bashls', {})
vim.lsp.config('rust_analyzer', {
    flags = {
        exit_timeout = 0,
    },
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                autoreload = true,
            },
            checkOnSave = true,
            check = {
                command = 'clippy',
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
    },
})
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            telemetry = { enable = false },
            workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
            },
            diagnostics = {
                disable = { 'redefined-local' },
            },
        },
    },
})

vim.lsp.enable({
    'ts_ls',
    'clangd',
    'gopls',
    'zls',
    'pyright',
    'lua_ls',
    'rust_analyzer',
    'efm',
})

local diagnostic_signs = {
    Error = '\u{f057} ',
    Warn = '\u{f071} ',
    Hint = '\u{ea61}',
    Info = '\u{f05a}',
}

vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = function(_, _)
        return { current_line = true }
    end,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
            [vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
            [vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
            [vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
        },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = 'rounded',
        source = true,
        header = '',
        prefix = '',
        focusable = false,
        style = 'minimal',
    },
})

require('lsp.mason')
