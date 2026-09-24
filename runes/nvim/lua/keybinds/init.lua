local lib = require('lib')

local group = vim.api.nvim_create_augroup('user-keybinds', { clear = true })

-- clear selection
vim.keymap.set('n', '<leader><leader>', function()
    vim.cmd('nohlsearch')
    require('mini.snippets').session.stop()
end)

-- Ctrl+C and Ctrl+X
vim.keymap.set('v', '<C-c>', '"+y')
vim.keymap.set('v', '<C-x>', '"+d')

-- fast replace
vim.keymap.set('n', 'S', [[:%s/\<<C-r><C-w>\>/]])

-- full screen this buffer in a new tab
vim.keymap.set('n', '<c-w>o', ':tab split<CR>')

-- navigation
vim.keymap.set('n', '<C-j>', '<C-W>j')
vim.keymap.set('n', '<C-k>', '<C-W>k')
vim.keymap.set('n', '<C-l>', '<C-W>l')
vim.keymap.set('n', '<C-h>', '<C-W>h')

vim.keymap.set('n', '<M-h>', '<C-w>H')
vim.keymap.set('n', '<M-j>', '<C-w>J')
vim.keymap.set('n', '<M-k>', '<C-w>K')
vim.keymap.set('n', '<M-l>', '<C-w>L')

-- split resize
vim.keymap.set('n', '<M-K>', '<C-w>+')
vim.keymap.set('n', '<M-J>', '<C-w>-')
vim.keymap.set('n', '<M-H>', '<C-w><')
vim.keymap.set('n', '<M-L>', '<C-w>>')

-- Fix L and H in visual mode
vim.keymap.set('v', 'H', '^')
vim.keymap.set('v', 'L', '$')

-- alt tab
vim.keymap.set('n', '<leader><Tab>', '<C-^>')

-- confy quit
vim.keymap.set('n', '<C-q>', ':q<CR>')

-- easier start and end
vim.keymap.set('n', 'H', '^')
vim.keymap.set('n', 'L', '$')

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'sh' },
    group = group,
    callback = function(ev)
        vim.keymap.set(
            'n',
            '<leader>s',
            ':sp | term shellcheck -x %<CR>',
            { buf = ev.buf }
        )
    end,
})

-- ====================================================
-- overrides
-- ====================================================

-- no help
vim.keymap.set('n', '<F1>', ':echo<CR>')
vim.keymap.set('i', '<F1>', '<C-o>:echo<CR>')

-- replaces selected text without losing what you yanked
vim.keymap.set(
    'x',
    'p',
    [["_dP]],
    { desc = 'Paste over selection without losing yanked text' }
)

-- search results are always at the center of the screen
vim.keymap.set(
    'n',
    'n',
    'nzzzv',
    { desc = 'keep search results at the center of the screen' }
)
vim.keymap.set(
    'n',
    'N',
    'Nzzzv',
    { desc = 'keep search results at the center of the screen' }
)

vim.keymap.set('n', '<leader>u', function()
    vim.cmd.packadd('nvim.undotree')
    require('undotree').open()
end, { desc = 'toggle builtin undotree' })

-- ====================================================
-- LSP
-- ====================================================
vim.keymap.set('n', '[e', function()
    vim.diagnostic.jump({ count = -1 })
end)

vim.keymap.set('n', ']e', function()
    vim.diagnostic.jump({ count = 1 })
end)

vim.keymap.set('n', '<leader>c', vim.lsp.buf.rename, { silent = true })
vim.keymap.set('n', '<A-Return>', vim.lsp.buf.code_action, { silent = true })

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set(
    'n',
    '<leader>ld',
    vim.diagnostic.open_float,
    { desc = 'Show line diagnostics' }
)

-- ====================================================
-- PLUGINS
-- ====================================================
repeat
    local term = lib.try_require('floatty')
    if term == nil then
        vim.notify('Ignoring keybinds for floatty', vim.log.levels.WARN)
        break
    end
    term = term.setup({})
    vim.keymap.set('n', '<leader>t', term.toggle)
    vim.keymap.set('t', '<leader>t', term.toggle)
until true

repeat
    local mini_keymap = lib.try_require('mini.keymap')
    if mini_keymap == nil then
        vim.notify('Ignoring keybinds using mini.keymap', vim.log.levels.WARN)
        break
    end
    local map_multistep = mini_keymap.map_multistep
    map_multistep('i', '<Tab>', { 'pmenu_next' })
    map_multistep('i', '<C-n>', { 'pmenu_next' })
    map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
    map_multistep('i', '<C-p>', { 'pmenu_prev' })
    map_multistep('i', '<C-y>', { 'pmenu_accept' })
    map_multistep('i', '<C-u>', { 'pmenu_accept' })
    local cancel_completion = {
        condition = function()
            return vim.fn.pumvisible() == 1
        end,
        action = function()
            return '<C-e><CR>'
        end,
    }
    map_multistep('i', '<CR>', { cancel_completion, 'minipairs_cr' })
until true

repeat
    local MiniFiles = lib.try_require('mini.files')
    if MiniFiles == nil then
        vim.notify('Ignoring keybinds using mini.files', vim.log.levels.WARN)
        break
    end
    vim.keymap.set('n', '\\', function()
        if not MiniFiles.close() then
            local file = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
            while
                vim.fn.filereadable(file) == 0
                and vim.fn.isdirectory(file) == 0
                and file ~= '/'
            do
                vim.notify("can't read " .. file, vim.log.levels.WARN)
                file = vim.fs.dirname(file)
            end
            if file == '/' then
                MiniFiles.open()
            else
                MiniFiles.open(file)
            end
        end
    end)

    vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        group = group,
        callback = function(args)
            local buf_id = args.data.buf_id
            vim.bo[buf_id].buftype = 'acwrite'
            vim.api.nvim_create_autocmd('BufWriteCmd', {
                buffer = buf_id,
                group = group,
                callback = function()
                    MiniFiles.synchronize()
                end,
            })
        end,
    })
until true

repeat
    local MiniPick = lib.try_require('mini.pick')
    if MiniPick == nil then
        vim.notify('Ignoring keybinds using mini.pick', vim.log.levels.WARN)
        break
    end

    vim.keymap.set('n', '<leader>p', function()
        MiniPick.builtin.files({ tool = 'rg' })
    end)
    vim.keymap.set('n', '<leader>b', function()
        MiniPick.builtin.buffers()
    end)
    vim.keymap.set('n', '<leader>l', function()
        MiniPick.builtin.grep_live({ tool = 'rg' })
    end)
until true

repeat
    local MiniExtra = lib.try_require('mini.extra')
    if MiniExtra == nil then
        vim.notify('Ignoring keybinds using mini.extra', vim.log.levels.WARN)
        break
    end
    vim.keymap.set('n', 'gD', function()
        MiniExtra.pickers.lsp({ scope = 'type_definition' })
    end)
    vim.keymap.set('n', '<leader>xx', function()
        MiniExtra.pickers.diagnostic()
    end)
    vim.keymap.set('n', 'gh', function()
        MiniExtra.pickers.lsp({ scope = 'references' })
    end)
until true

repeat
    local MiniDiff = lib.try_require('mini.diff')
    if MiniDiff == nil then
        vim.notify('Ignoring keybinds using mini.diff', vim.log.levels.WARN)
        break
    end

    vim.keymap.set('n', '<leader>d', function()
        MiniDiff.toggle_overlay(0)
    end)
until true

-- ====================================================
-- quick run
-- ====================================================

local function save_compile_run(ft, spec)
    vim.api.nvim_create_autocmd('FileType', {
        pattern = ft,
        group = group,
        callback = function(ev)
            vim.keymap.set('n', '<leader>r', function()
                vim.cmd([[write]])
                if spec.compile then
                    local ok, err = pcall(spec.compile)
                    if not ok then
                        vim.notify(
                            'Compile failed: ' .. tostring(err),
                            vim.log.levels.ERROR
                        )
                        return
                    end
                    if vim.v.shell_error ~= 0 then
                        vim.notify(
                            'Compile failed (exit ' .. vim.v.shell_error .. ')',
                            vim.log.levels.ERROR
                        )
                        return
                    end
                end
                spec.run()
            end, { buffer = ev.buf })
        end,
    })
end

local function path_is_absolute()
    return vim.fn.expand('%'):sub(1, 1) == '/'
end

save_compile_run('c', {
    compile = function()
        if
            vim.fn.filereadable('makefile') == 1
            or vim.fn.filereadable('Makefile') == 1
        then
            vim.cmd([[make]])
        else
            vim.cmd([[make CFLAGS='-lm -g' %:r]])
        end
    end,
    run = function()
        if
            vim.fn.filereadable('makefile') == 1
            or vim.fn.filereadable('Makefile') == 1
        then
            return
        end
        if path_is_absolute() then
            vim.cmd([[!%:r]])
        else
            vim.cmd([[!./%:r]])
        end
    end,
})

save_compile_run('cpp', {
    compile = function()
        if
            vim.fn.filereadable('makefile') == 1
            or vim.fn.filereadable('Makefile') == 1
        then
            vim.cmd([[make]])
        else
            vim.cmd([[!clang++ -std=c++20 % -o %:r]])
        end
    end,
    run = function()
        if path_is_absolute() then
            vim.cmd([[!%:r]])
        else
            vim.cmd([[!./%:r]])
        end
    end,
})

save_compile_run('rust', {
    compile = function()
        if vim.fn.executable('rust-script') == 0 then
            vim.cmd(
                [[!rustc % --allow dead_code --allow unused_variables --edition 2021 -o %:r]]
            )
        end
    end,
    run = function()
        if vim.fn.executable('rust-script') == 1 then
            vim.cmd([[!rust-script %]])
        else
            if path_is_absolute() then
                vim.cmd([[!%:r]])
            else
                vim.cmd([[!./%:r]])
            end
        end
    end,
})

save_compile_run('go', {
    run = function()
        vim.cmd([[!go run %]])
    end,
})

save_compile_run('kotlin', {
    compile = function()
        vim.cmd([[!kotlinc -d %:h %]])
    end,
    run = function()
        local f = vim.fn.expand('%:t:r')
        vim.cmd(
            "execute '!kotlin -cp %:h "
                .. f:sub(1, 1):upper()
                .. f:sub(2)
                .. "Kt'"
        )
    end,
})

save_compile_run('javascript', {
    run = function()
        vim.cmd([[!node %]])
    end,
})

save_compile_run('sh', {
    run = function()
        vim.cmd([[!bash %]])
    end,
})

save_compile_run('spell', {
    run = function()
        vim.cmd([[!bash %]])
    end,
})

vim.keymap.set('n', '<leader>r', function()
    vim.cmd([[write]])
    vim.cmd("exec '!" .. vim.bo.filetype .. " %'")
end)

require('keybinds.writting')
