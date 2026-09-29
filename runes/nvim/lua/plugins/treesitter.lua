local ensure_installed = {
    'rust',
    'c',
    'markdown',
    'lua',
    'python',
    'go',
    'typescript',
    'javascript',
    'css',
    'tsx',
    'html',
    'json',
    'bash',
    'http',
    'dockerfile',
}

return {
    after = function()
        local treesitter = require('nvim-treesitter')
        treesitter.setup({})
        local config = require('nvim-treesitter.config')

        local already_installed = config.get_installed()
        local parsers_to_install = {}

        for _, parser in ipairs(ensure_installed) do
            if not vim.tbl_contains(already_installed, parser) then
                table.insert(parsers_to_install, parser)
            end
        end

        if #parsers_to_install > 0 then
            treesitter.install(parsers_to_install)
        end

        local group =
            vim.api.nvim_create_augroup('TreeSitterConfig', { clear = true })
        vim.api.nvim_create_autocmd('FileType', {
            group = group,
            callback = function(args)
                if
                    vim.list_contains(
                        config.get_installed(),
                        vim.treesitter.language.get_lang(args.match)
                    )
                then
                    vim.treesitter.start(args.buf)
                end
            end,
        })

        -- After parser installation, activate treesitter in already-open buffers
        vim.api.nvim_create_autocmd('User', {
            pattern = 'TSUpdate',
            group = group,
            callback = function()
                local installed = config.get_installed()
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.api.nvim_buf_is_loaded(buf) then
                        local ft = vim.bo[buf].filetype
                        local lang = vim.treesitter.language.get_lang(ft)
                        if lang and vim.list_contains(installed, lang) then
                            pcall(vim.treesitter.start, buf)
                        end
                    end
                end
            end,
        })
    end,
}
