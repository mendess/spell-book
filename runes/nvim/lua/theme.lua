local au = require('utils.au')
local set = vim.opt

-- theme.lua

-- vim.opt.termguicolors = true
-- vim.g.base16colorsspace = 256

local base16_costumize = function()
    -- vim.call('Base16hi', 'MatchParen', '', '', '', '', 'bold', '')
    -- vim.call('Base16hi', 'Comment', vim.g.base16_gui04, '', vim.g.base16_cterm04, '', '', '')
end

au.group('on-change-colorscheme', function(g)
    g.ColorScheme = { '*', base16_costumize }
    g.ColorScheme = { '*',  'highlight Normal guibg=NONE' }
end)

local base16 = require('base16')
base16(base16.themes['default-dark'], true, {
    transparent_bg = true,
    Comment = function(theme, cterm)
        return theme.base04, nil, cterm.cterm04, nil, nil, nil
    end,
    MatchParen = function(theme, cterm)
        return nil, nil, nil, nil, 'bold', nil
    end,
})
--vim.cmd 'colorscheme base16-default-dark'

-- assign syntax to some special files
au.group('syntax-fix', function(g)
    au.BufReadPre = {
        {'*.spell', '*xinitrc'},
        function() set.filetype ='sh' end
    }
    au.BufReadPre = { '*.glsl', function() set.filetype = 'c' end }
    au.BufReadPre = { '*.hbs', function() set.filetype = 'html' end }
    au(
        {'BufNewFile', 'BufRead', 'BufReadPost', 'BufWritePost'},
        { '*.h', function() set.filetype = 'c' end }
    )
    au(
        {'BufRead', 'BufNewFile'},
        {
            { '*.pde', '*.ino' },
            function() set.filetype = 'arduino' end
        }
    )
end)

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

