local group = vim.api.nvim_create_augroup('user-theme', { clear = true })

require('kanagawa').setup({
    commentStyle = { italic = false },
    keywordStyle = { italic = false },
    statementStyle = { bold = false, italic = false },
    typeStyle = { italic = false },
    variablebuiltinStyle = { italic = false },
    transparent = true,
    colors = {
        theme = {
            all = {
                ui = {
                    bg_gutter = 'none',
                },
            },
        },
    },
    overrides = function(colors)
        local theme = colors.theme
        return {
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
            TelescopeResultsNormal = {
                fg = theme.ui.fg_dim,
                bg = theme.ui.bg_m1,
            },
            TelescopeResultsBorder = {
                fg = theme.ui.bg_m1,
                bg = theme.ui.bg_m1,
            },
            TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            TelescopePreviewBorder = {
                bg = theme.ui.bg_dim,
                fg = theme.ui.bg_dim,
            },
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = 15 },
            PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
            rustModPath = { fg = theme.syn.constant },
            rustDerive = { fg = theme.syn.constant },
            rustAttribute = { fg = theme.syn.constant },
            rustMacro = { fg = theme.syn.constant },
            MiniIndentscopeSymbol = { fg = colors.palette.fujiGray },
            MiniIndentscopeSymbolOff = { link = 'MiniIndentscopeSymbol' },
        }
    end,
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead', 'BufWritePost' }, {
    pattern = '*.h',
    group = group,
    callback = function()
        vim.opt.filetype = 'c'
    end,
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead', 'BufWritePost' }, {
    pattern = '*.crs',
    group = group,
    callback = function()
        vim.opt.filetype = 'rust'
    end,
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead', 'BufWritePost' }, {
    pattern = '*.sls',
    group = group,
    callback = function()
        vim.opt.filetype = 'yaml'
    end,
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead', 'BufWritePost' }, {
    pattern = '*.jinja',
    group = group,
    callback = function()
        vim.opt.filetype = 'yaml'
    end,
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead', 'BufWritePost' }, {
    pattern = '*.spell',
    group = group,
    callback = function()
        vim.opt.filetype = 'sh'
    end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
    group = group,
    callback = function()
        -- Strip italic from all treesitter highlight groups
        for _, hl_name in ipairs(vim.fn.getcompletion('@', 'highlight')) do
            local hl = vim.api.nvim_get_hl(0, { name = hl_name })
            if hl.italic then
                hl.italic = false
                vim.api.nvim_set_hl(0, hl_name, hl)
            end
        end
    end,
})

vim.cmd.colorscheme('kanagawa')

function Fugitive_status_line()
    local ok, branch = pcall(vim.fn.FugitiveHead)
    if ok and branch ~= '' then
        return string.format('[%s]', branch)
    else
        return ''
    end
end
vim.opt.statusline =
    [[%<%f %#StatusLineNC#%{v:lua.Fugitive_status_line()}%#StatusLine# %h%w%m%r%=%-14.(%l,%c%V%) %P]]
