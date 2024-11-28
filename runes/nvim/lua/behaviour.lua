local au = require('utils.au')
local command = require('utils.command')
local set = vim.opt
local expand = vim.fn.expand
local mkdir = vim.fn.mkdir

-- tabs
set.tabstop = 4
set.softtabstop = 4
set.expandtab = true
set.shiftwidth = 4
set.smarttab = true
au.group('tab-settings', function(g)
    g.BufEnter = {
        { '*css', '*scss', '*.html', '*hbs', "*.svelte", "*.tsx" },
        function()
            set.tabstop = 2
            set.shiftwidth = 2
        end
    }
end)

set.splitbelow = true
set.splitright = true
set.path='**'
-- line numbers
set.number = true
set.relativenumber = true
-- au.group('number-toggle', function(g)
--     g(
--         {'BufEnter', 'FocusGained', 'InsertLeave'},
--         { '*', function() set.relativenumber = true end }
--     )
--     g(
--         {'BufLeave', 'FocusLost', 'InsertEnter'},
--         { '*', function() set.relativenumber = false end }
--     )
-- end)

set.scrolloff=4
set.hidden = true
set.ignorecase = true
set.smartcase = true
au.group('bad-ws', function(g) g.BufWritePre = { '*', '%s/\\s\\+$//e' } end)

if vim.fn.has('nvim') == 1 then
    au.group('term', function(g)
        g.TermOpen = {
            '*',
            function()
                -- vim.cmd 'autocmd! number-toggle'
                vim.wo.number = false
                vim.wo.relativenumber = false
                vim.cmd 'startinsert'
            end
        }
    end)
end

set.undodir = vim.fn.stdpath('cache')..'/vimundo'
set.undofile = true

au.group('read-extra-file-types', function(g)
    g.BufReadPre = {
        '*.pdf',
        function()
            vim.cmd [[execute '!exec zathura "%" &' | :q!]]
        end
    }
end)

set.icm = 'nosplit'

au.group('mkdir', function(g)
    g.BufWritePre = {
        '*',
        function()
            mkdir(expand("<afile>:p:h"), "p")
        end
    }
end)

-- fix my mistypes
command.W = 'w'
command.Q ='q'
command.WQ = 'wq'
command.Wq = 'wq'

au.group('himalaya-bad-ws', function(g)
    g.Filetype = {
        'himalaya-msg-list',
        ':HideBadWhitespace'
    }
    -- g.Filetype = {
    --     'neo-tree',
    --     ':HideBadWhitespace'
    -- }
    -- g.BufEnter = {
    --     '*neo-tree*',
    --     ':HideBadWhitespace'
    -- }
    g.BufEnter = {
        'Himalaya*',
        ':HideBadWhitespace',
    }
end)

set.foldmethod = 'indent'
set.foldlevelstart = 99

set.mouse = ''
