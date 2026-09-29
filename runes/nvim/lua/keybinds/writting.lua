local lib = require('lib')

local group = vim.api.nvim_create_augroup('user-writting', { clear = true })

lib.iabbrev('Ture', 'True')
lib.iabbrev('Flase', 'False')
lib.iabbrev('Stirng', 'String')
lib.iabbrev('Srting', 'String')
lib.iabbrev('Stinrg', 'String')
lib.iabbrev('tho', 'though')
lib.iabbrev('Slef', 'Self')
lib.iabbrev('cosnt', 'const')
lib.iabbrev('Lable', 'Label')
lib.iabbrev('Tiem', 'item')
lib.iabbrev('Deamon', 'Daemon')
lib.iabbrev('reutrn', 'return')
lib.iabbrev('retunr', 'return')
lib.iabbrev('reutnr', 'return')
lib.iabbrev('brian', 'brain')
lib.iabbrev('asyuc', 'async')
lib.iabbrev('asycn', 'async')
lib.iabbrev('awiat', 'await')
lib.iabbrev('Comming', 'Coming')

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'java',
    callback = function()
        lib.iabbrev('sout', 'System.out.println')
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'markdown', 'tex' },
    group = group,
    callback = function(ev)
        if vim.bo[ev.buf].buftype == 'nofile' then
            return
        end
        vim.wo.linebreak = true
        vim.bo[ev.buf].textwidth = 80
        lib.iabbrev('nao', 'não', { buffer = true })
        lib.iabbrev('tb', 'também', { buffer = true })
        lib.iabbrev('tambem', 'também', { buffer = true })
        lib.iabbrev('ja', 'já', { buffer = true })
        lib.iabbrev('numero', 'número', { buffer = true })
        lib.vim.keymap.set('n', 'k', 'gk', { silent = true, buf = ev.buf })
        vim.keymap.set('n', 'j', 'gj', { silent = true, buf = ev.buf })
        vim.keymap.set('n', '0', 'g0', { silent = true, buf = ev.buf })
        vim.keymap.set('n', '$', 'g$', { silent = true, buf = ev.buf })
    end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = { 'content/*md' },
    group = group,
    callback = function()
        if not vim.opt.modified:get() then
            return
        end
        local save_cursor = vim.fn.getpos('.')
        vim.fn.cursor(1, 1)
        local top = vim.fn.search('+++', 'c')
        local btm = vim.fn.search('+++')
        if top == 0 then
            vim.fn.append(0, {
                '+++',
                'title =',
                'date =',
                '#[extra]',
                '#background = ""',
                '#[taxonomies]',
                '#tags = ["tag"]',
                '+++',
            })
            top = 1
            btm = 6
        end
        vim.cmd(
            string.format(
                'keepjumps exe "%d,%ds/^title =.*/title = \\"%s\\"/"',
                top,
                btm,
                vim.fn
                    .getline(vim.fn.search('^#[^#]'))
                    :gsub('^#[ ]*', '')
                    :gsub('"', '\\"')
            )
        )

        vim.cmd(
            string.format(
                'keepjumps exe "%d,%ds/^date =.*/date = %s/"',
                top,
                btm,
                os.date('%F')
            )
        )

        vim.fn.histdel('search', -1)
        vim.fn.setpos('.', save_cursor)
    end,
})

vim.keymap.set('n', '<leader>o', ':setlocal spell! spelllang=en_gb<CR>')
vim.keymap.set('n', '<leader>O', ':setlocal spell! spelllang=en_gb,pt_pt<CR>')
