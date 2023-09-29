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
            set.linebreak = true
            set.textwidth = 80
            inoremap('`A', 'À')
            inoremap('`E', 'È')
            inoremap('`a', 'à')
            inoremap("'a", 'á')
            inoremap('`e', 'é')
            inoremap("'o", 'ó')
            inoremap("'u", 'ú')
            iabbrev('nao', 'não')
            iabbrev('tb', 'também')
            iabbrev('tambem', 'também')
            iabbrev('ja', 'já')
            iabbrev('numero', 'número')
            mapx.group({ silent = true, buffer = true }, function()
                nnoremap('k', 'gk')
                nnoremap('j', 'gj')
                nnoremap('0', 'g0')
                nnoremap('$', 'g$')
            end)
        end
    }
    g.Filetype = {
        'tex',
        function()
            nnoremap('<leader>s', function()
                local file = expand('%:p')
                vim.cmd('silent !pdflatex --shell-escape ' .. file .. '> /dev/null &')
            end)
            command.Re = function()
                vim.cmd('!pdflatex --shell-escape ' .. expand('%:p'))
            end
            nnoremap('<leader>r', function()
                local file = expand('%:r') .. '.pdf'
                os.execute('exec zathura ' .. file ..' >/dev/null &')
            end)
            inoremap(',tt', [[\texttt{}<Space><++><Esc>T{i]])
            inoremap(',ve', [[\verb!!<Space><++><Esc>T!i]])
            inoremap(',bf', [[\textbf{}<Space><++><Esc>T{i]])
            inoremap(',it', [[\textit{}<Space><++><Esc>T{i]])
            inoremap(',st', [[\section{}<Return><++><Esc>T{i]])
            inoremap(',sst', [[\subsection{}<Return><Return><++><Esc>2kt}a]])
            inoremap(',ssst', [[\subsubsection{}<Return><Return><++><Esc>2kt}a]])
            inoremap(',bit', [[\begin{itemize}<CR><CR>\end{itemize}<Return><++><Esc>kki<Tab>\item<Space>]])
            inoremap(',bfi', [[\begin{figure}[H]<CR><CR>\end{figure}<Return><++><Esc>kki<Tab>\centering<CR><Tab>\includegraphics{}<CR>\caption{<++>}<Esc>k$i]])
            inoremap(',beg', [[\begin{<++>}<Esc>yyp0fbcwend<Esc>O<Tab><++><Esc>k0<Esc>/<++><Enter>"_c4l]])
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

nnoremap('<leader>o', ':setlocal spell! spelllang=en_gb<CR>')
nnoremap('<leader>O', ':setlocal spell! spelllang=en_gb,pt_pt<CR>')
nnoremap('^M', 'z=')
