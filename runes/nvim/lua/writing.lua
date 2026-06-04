local iabbrev = require('utils.misc').iabbrev
local au = require('utils.au')
local command = require('utils.command')

local set = vim.opt
local expand = vim.fn.expand
local fn = vim.fn

local Iabbrev = function(bad, good)
    iabbrev(bad, good)
    iabbrev(bad:lower(), good:lower())
end

Iabbrev('Ture', 'True')
Iabbrev('Flase', 'False')
Iabbrev('Stirng', 'String')
Iabbrev('Srting', 'String')
Iabbrev('Stinrg', 'String')
iabbrev('tho', 'though')
Iabbrev('Slef', 'Self')
iabbrev('cosnt', 'const')
Iabbrev('Lable', 'Label')
Iabbrev('Tiem', 'item')
Iabbrev('Deamon', 'Daemon')
iabbrev('reutrn', 'return')
iabbrev('retunr', 'return')
iabbrev('reutnr', 'return')
iabbrev('brian', 'brain')
iabbrev('asyuc', 'async')
iabbrev('asycn', 'async')
iabbrev('awiat', 'await')
iabbrev('Comming', 'Coming')

au.group('writing-opts', function(g)
    g.Filetype = {
        {'markdown', 'tex'},
        function()
            print("using writing mode")
            set.linebreak = true
            set.textwidth = 80
            vim.keymap.set('i', '`A', 'À', { noremap = true })
            vim.keymap.set('i', '`E', 'È', { noremap = true })
            vim.keymap.set('i', '`a', 'à', { noremap = true })
            vim.keymap.set('i', "'a", 'á', { noremap = true })
            vim.keymap.set('i', '`e', 'é', { noremap = true })
            vim.keymap.set('i', "'o", 'ó', { noremap = true })
            vim.keymap.set('i', "'u", 'ú', { noremap = true })
            iabbrev('nao', 'não')
            iabbrev('tb', 'também')
            iabbrev('tambem', 'também')
            iabbrev('ja', 'já')
            iabbrev('numero', 'número')
            vim.keymap.set('n', 'k', 'gk', { noremap = true, silent = true, buffer = true })
            vim.keymap.set('n', 'j', 'gj', { noremap = true, silent = true, buffer = true })
            vim.keymap.set('n', '0', 'g0', { noremap = true, silent = true, buffer = true })
            vim.keymap.set('n', '$', 'g$', { noremap = true, silent = true, buffer = true })
        end
    }
    g.Filetype = {
        'tex',
        function()
            vim.keymap.set('n', '<leader>s', function()
                local file = expand('%:p')
                vim.cmd('silent !pdflatex --shell-escape ' .. file .. '> /dev/null &')
            end, { noremap = true, buffer = true })
            command.Re = function()
                vim.cmd('!pdflatex --shell-escape ' .. expand('%:p'))
            end
            vim.keymap.set('n', '<leader>r', function()
                local file = expand('%:r') .. '.pdf'
                os.execute('exec zathura ' .. file ..' >/dev/null &')
            end, { noremap = true, buffer = true })
            vim.keymap.set('i', ',tt', [[\texttt{}<Space><++><Esc>T{i]])
            vim.keymap.set('i', ',ve', [[\verb!!<Space><++><Esc>T!i]])
            vim.keymap.set('i', ',bf', [[\textbf{}<Space><++><Esc>T{i]])
            vim.keymap.set('i', ',it', [[\textit{}<Space><++><Esc>T{i]])
            vim.keymap.set('i', ',st', [[\section{}<Return><++><Esc>T{i]])
            vim.keymap.set('i', ',sst', [[\subsection{}<Return><Return><++><Esc>2kt}a]])
            vim.keymap.set('i', ',ssst', [[\subsubsection{}<Return><Return><++><Esc>2kt}a]])
            vim.keymap.set('i', ',bit', [[\begin{itemize}<CR><CR>\end{itemize}<Return><++><Esc>kki<Tab>\item<Space>]])
            vim.keymap.set('i', ',bfi', [[\begin{figure}[H]<CR><CR>\end{figure}<Return><++><Esc>kki<Tab>\centering<CR><Tab>\includegraphics{}<CR>\caption{<++>}<Esc>k$i]])
            vim.keymap.set('i', ',beg', [[\begin{<++>}<Esc>yyp0fbcwend<Esc>O<Tab><++><Esc>k0<Esc>/<++><Enter>"_c4l]])
        end
    }
    g.BufWritePre = {
        'content/*.md',
        function()
            if not vim.opt.modified:get() then return end
            local save_cursor = fn.getpos('.')
            fn.cursor(1, 1)
            local top = fn.search('+++', 'c')
            local btm = fn.search('+++')
            if top == 0 then
                fn.append(0, {
                    '+++',
                    'title =',
                    'date =',
                    '#[extra]',
                    '#background = ""',
                    '#[taxonomies]',
                    '#tags = ["tag"]',
                    '+++'
                })
                top = 1
                btm = 6
            end
            vim.cmd(string.format(
                'keepjumps exe "%d,%ds/^title =.*/title = \\"%s\\"/"',
                top,
                btm,
                fn.getline(fn.search('^#[^#]')):gsub('^#[ ]*', ""):gsub('"', '\\"')
            ))

            vim.cmd(string.format(
                'keepjumps exe "%d,%ds/^date =.*/date = %s/"',
                top,
                btm,
                os.date('%F')
            ))

            fn.histdel('search', -1)
            fn.setpos('.', save_cursor)
        end
    }
    vim.cmd [[au! BufWritePre content/pages/*md]]
end)

vim.keymap.set('n', '<leader>o', ':setlocal spell! spelllang=en_gb<CR>', { noremap = true })
vim.keymap.set('n', '<leader>O', ':setlocal spell! spelllang=en_gb,pt_pt<CR>', { noremap = true })
vim.keymap.set('n', '^M', 'z=', { noremap = true })
