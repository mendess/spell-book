local group = vim.api.nvim_create_augroup('user-config', { clear = true })

-- indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = {
        'css',
        'scss',
        'html',
        'htmldjango',
        'svelte',
        'typescriptreact',
        'typescript',
        'javascript',
        'javascriptreact',
    },
    callback = function(ev)
        vim.bo[ev.buf].tabstop = 2
        vim.bo[ev.buf].shiftwidth = 2
        vim.bo[ev.buf].softtabstop = 2
    end,
})

-- splitting
vim.opt.splitbelow = true
vim.opt.splitright = true

-- numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- scrolling
vim.opt.scrolloff = 4

-- hide markup
vim.opt.hidden = true
vim.opt.conceallevel = 2

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- discipline
vim.opt.colorcolumn = '81'

-- no split for incremental commands
vim.opt.inccommand = 'split'

-- disable mouse
vim.opt.mouse = ''

-- pretty hover menus
vim.opt.pumblend = 15

-- prettier line wrapping
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = '> '

-- show tabs
vim.opt.list = true
vim.opt.listchars = 'tab:>-'
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'go' },
    group = group,
    callback = function()
        vim.cmd('setlocal listchars=tab:\\ \\ ')
    end,
})

-- completion
vim.opt.completeopt = { 'menu', 'menuone', 'noinsert' }

-- window borders
vim.opt.winborder = 'rounded'

-- persit edit state across vim invocations
vim.opt.undodir = vim.fn.stdpath('cache') .. '/vimundo'
vim.opt.undofile = true

vim.api.nvim_create_autocmd('BufReadPost', {
    group = group,
    desc = 'Restore last cursor position',
    callback = function()
        if vim.o.diff then -- except in diff mode
            return
        end

        local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
        local last_line = vim.api.nvim_buf_line_count(0)

        local row = last_pos[1]
        if row < 1 or row > last_line then
            return
        end

        pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
    end,
})

vim.api.nvim_create_autocmd('BufReadPre', {
    desc = 'open pdfs',
    group = group,
    pattern = { '*.pdf' },
    callback = function(ev)
        local path = vim.api.nvim_buf_get_name(ev.buf)
        if vim.fn.executable('xdg-open') == 1 then
            vim.system({ 'xdg-open', path }, { detach = true })
        else
            vim.notify('xdg-open not found', vim.log.levels.ERROR)
        end
        -- wait for vim to finish initializing the buffer before deleting it
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(ev.buf) then
                vim.api.nvim_buf_delete(ev.buf, { force = true })
            end
        end)
    end,
})

vim.api.nvim_create_autocmd('BufReadPre', {
    desc = 'mkdir parents of current file',
    group = group,
    callback = function()
        vim.fn.mkdir(vim.fn.expand('<afile>:p:h'), 'p')
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    group = group,
    callback = function()
        vim.hl.on_yank({ timeout = 100 })
    end,
})
