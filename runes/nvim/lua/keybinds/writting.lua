local group = vim.api.nvim_create_augroup('user-writting', { clear = true })

local function iabbrev(bad, good, opts)
    opts = opts or {}
    local scope = opts.buffer and '<buffer>' or ''

    vim.cmd('ia ' .. scope .. bad .. ' ' .. good)
    vim.cmd('ia ' .. scope .. bad:lower() .. ' ' .. good:lower())
end

iabbrev('Ture', 'True')
iabbrev('Flase', 'False')
iabbrev('Stirng', 'String')
iabbrev('Srting', 'String')
iabbrev('Stinrg', 'String')
iabbrev('tho', 'though')
iabbrev('Slef', 'Self')
iabbrev('cosnt', 'const')
iabbrev('Lable', 'Label')
iabbrev('Tiem', 'item')
iabbrev('Deamon', 'Daemon')
iabbrev('reutrn', 'return')
iabbrev('retunr', 'return')
iabbrev('reutnr', 'return')
iabbrev('brian', 'brain')
iabbrev('asyuc', 'async')
iabbrev('asycn', 'async')
iabbrev('awiat', 'await')
iabbrev('Comming', 'Coming')

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'markdown', 'tex' },
    group = group,
    callback = function(ev)
        if vim.bo[ev.buf].buftype == 'nofile' then
            return
        end
        vim.wo.linebreak = true
        vim.bo[ev.buf].textwidth = 80
        iabbrev('nao', 'não', { buffer = true })
        iabbrev('tb', 'também', { buffer = true })
        iabbrev('tambem', 'também', { buffer = true })
        iabbrev('ja', 'já', { buffer = true })
        iabbrev('numero', 'número', { buffer = true })
        vim.keymap.set('n', 'k', 'gk', { silent = true, buf = ev.buf })
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

