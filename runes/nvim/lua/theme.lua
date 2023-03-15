local au = require('utils.au')
local set = vim.opt
local misc = require('utils.misc')
local command = require('utils.command')
local dbg = require('utils.dbg')

-- theme.lua

set.termguicolors = true

function set_base16()
    local base16 = require('base16')
    vim.cmd('colorscheme default')
    base16(base16.themes['default-dark'], true, {
        transparent_bg = true,
        Comment = function(theme, cterm)
            return theme.base04, nil, cterm.cterm04, nil, nil, nil
        end,
        MatchParen = function(theme, cterm)
            return nil, nil, nil, nil, 'bold', nil
        end,
    })
end

misc.if_require_do('base16', function(base16)
    -- set_base16()
end)

vim.g.everforest_background = 'hard'
vim.g.everforest_better_performance = 1
vim.g.everforest_disable_italic_comment = 1
vim.g.everforest_transparent_background = 2
vim.g.everforest_show_eob = 0

-- THE RULER OF DISCIPLINE
set.colorcolumn = '101'
au.group('even-more-discipline', function(g)
    g.BufEnter = {
        {'*.c', '*.h', '*.cpp', '*.hpp'},
        function() set.colorcolumn = '81' end
    }
    g.BufLeave = {
        '*',
        function() set.colorcolumn = '101' end
    }
end)

if vim.fn.has('nvim') == 1 then
    set.pumblend = 15
end

set.linebreak = true
set.breakindent = true
set.showbreak = '> '
-- au.group('disable-linebreak', function(g)
--     g(
--         {'BufEnter','BufRead'},
--         { '*.rs', function() set.linebreak = false end }
--     )
-- end)
set.conceallevel = 2
set.list = true
set.listchars = 'tab:>-'


-- vim.cmd('colorscheme everforest')
require('kanagawa').setup({
    commentStyle = { italic = false },
    keywordStyle = { italic = false },
    variablebuiltinStyle = { italic = false },
    terminalColors = false,
    transparent = true,
    colors = {
        theme = {
            all = {
                ui = {
                    bg_gutter = "none"
                }
            }
        }
    },
    overrides = function(colors)
        local theme = colors.theme
        return {
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
            TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
            TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
            TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = 15 },
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
            rustModPath = { fg = theme.syn.constant },
            rustDerive = { fg = theme.syn.constant },
            rustAttribute = { fg = theme.syn.constant },
            rustMacro = { fg = theme.syn.constant },
        }
    end,
})

vim.cmd('command SynID  echo synIDattr(synID(line("."), col("."), 1), "name")')

vim.cmd("colorscheme kanagawa")

function transparent_bg()
    vim.cmd('highlight Normal guibg=none')
    vim.cmd('highlight NonText guibg=none')
    vim.cmd('highlight EndOfBuffer guibg=none')
end
-- transparent_bg()

command.Bt = transparent_bg

-- assign syntax to some special files
au.group('syntax-fix', function(g)
    au(
        {'BufNewFile', 'BufRead', 'BufReadPost', 'BufWritePost'},
        { '*.h', function() set.filetype = 'c' end }
    )
end)

-- Hide all semantic highlights
-- for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
--   vim.api.nvim_set_hl(0, group, {})
-- end

