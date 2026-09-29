local lib = require('lib')

local group = vim.api.nvim_create_augroup('user-keybinds', { clear = true })

vim.keymap.set('n', '<leader><leader>', function()
    vim.cmd('nohlsearch')
    local snippets = lib.try_require('mini.snippets')
    if snippets ~= nil then
        snippets.session.stop()
    end
end, { desc = 'clear highlights and snippet helpers' })

vim.keymap.set('v', '<C-c>', '"+y', { desc = 'copy to system clipboard' })
vim.keymap.set('v', '<C-x>', '"+d', { desc = 'cut to system clipboard' })

vim.keymap.set(
    'n',
    'S',
    [[:%s/\<<C-r><C-w>\>/]],
    { desc = 'find and replace current word' }
)

vim.keymap.set(
    'n',
    '<c-w>o',
    ':tab split<CR>',
    { desc = 'fullscreen this buffer in a new tab' }
)

-- navigation
vim.keymap.set('n', '<C-j>', '<C-W>j', { desc = 'focus window down' })
vim.keymap.set('n', '<C-k>', '<C-W>k', { desc = 'focus window up' })
vim.keymap.set('n', '<C-l>', '<C-W>l', { desc = 'focus window right' })
vim.keymap.set('n', '<C-h>', '<C-W>h', { desc = 'focus window left' })

vim.keymap.set('n', '<M-j>', '<C-w>J', { desc = 'move window down' })
vim.keymap.set('n', '<M-k>', '<C-w>K', { desc = 'move window up' })
vim.keymap.set('n', '<M-l>', '<C-w>L', { desc = 'move window right' })
vim.keymap.set('n', '<M-h>', '<C-w>H', { desc = 'move window left' })

-- split resize
vim.keymap.set(
    'n',
    '<M-K>',
    '<C-w>+',
    { desc = 'increase split vertical size' }
)
vim.keymap.set(
    'n',
    '<M-J>',
    '<C-w>-',
    { desc = 'decrease split vertical size' }
)
vim.keymap.set(
    'n',
    '<M-H>',
    '<C-w><',
    { desc = 'increase split horizontal left size' }
)
vim.keymap.set(
    'n',
    '<M-L>',
    '<C-w>>',
    { desc = 'increase split horizontal right size' }
)

-- Fix L and H in visual mode
vim.keymap.set(
    { 'n', 'v' },
    'H',
    '^',
    { desc = 'bind H to jump to start of line' }
)
vim.keymap.set(
    { 'n', 'v' },
    'L',
    '$',
    { desc = 'bind L to jump to end of line' }
)

-- alt tab
vim.keymap.set(
    'n',
    '<leader><Tab>',
    '<C-^>',
    { desc = 'jump to previous buffer in this window' }
)

-- confy quit
vim.keymap.set('n', '<C-q>', ':q<CR>', { desc = 'quit vim' })

-- ====================================================
-- overrides
-- ====================================================

-- no help
vim.keymap.set('n', '<F1>', ':echo<CR>', { desc = 'disable help key' })
vim.keymap.set('i', '<F1>', '<C-o>:echo<CR>', { desc = 'disable help key' })

-- replaces selected text without losing what you yanked
vim.keymap.set(
    'x',
    'p',
    [["_dP]],
    { desc = 'Paste over selection without losing yanked text' }
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
end, { desc = 'jump to next diagnostic' })

vim.keymap.set('n', ']e', function()
    vim.diagnostic.jump({ count = 1 })
end, { desc = 'jump to prev diagnostic' })

vim.keymap.set(
    'n',
    '<leader>c',
    vim.lsp.buf.rename,
    { desc = 'lsp rename symbol ' }
)
vim.keymap.set(
    'n',
    '<A-Return>',
    vim.lsp.buf.code_action,
    { desc = 'lsp execute code action' }
)

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
    vim.keymap.set(
        'n',
        '<leader>t',
        term.toggle,
        { desc = 'toggle floating terminal' }
    )
    vim.keymap.set(
        't',
        '<leader>t',
        term.toggle,
        { desc = 'toggle floating terminal' }
    )
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
        desc = 'allow :w inside mini.files',
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
    end, { desc = 'ripgrep fuzzy finder' })
    vim.keymap.set('n', '<leader>b', function()
        MiniPick.builtin.buffers()
    end, { desc = 'buffer fuzzy finder' })
    vim.keymap.set('n', '<leader>l', function()
        MiniPick.builtin.grep_live({ tool = 'rg' })
    end, { desc = 'file fuzzy finder' })
until true

repeat
    local MiniExtra = lib.try_require('mini.extra')
    if MiniExtra == nil then
        vim.notify('Ignoring keybinds using mini.extra', vim.log.levels.WARN)
        break
    end
    vim.keymap.set('n', 'gD', function()
        MiniExtra.pickers.lsp({ scope = 'type_definition' })
    end, { desc = 'lsp type definitions picker' })
    vim.keymap.set('n', '<leader>xx', function()
        MiniExtra.pickers.diagnostic()
    end, { desc = 'lsp show diagnostic picker' })
    vim.keymap.set('n', 'gh', function()
        MiniExtra.pickers.lsp({ scope = 'references' })
    end, { desc = 'lsp show symbol references picker' })
until true

repeat
    local MiniDiff = lib.try_require('mini.diff')
    if MiniDiff == nil then
        vim.notify('Ignoring keybinds using mini.diff', vim.log.levels.WARN)
        break
    end

    vim.keymap.set('n', '<leader>d', function()
        MiniDiff.toggle_overlay(0)
    end, { desc = 'toggle git diff overlay' })
until true

repeat
    local treesitter_to = lib.try_require('nvim-treesitter-textobjects.select')
    if treesitter_to == nil then
        vim.notify(
            'Ignoring keybinds using treesitter-textobjects.select',
            vim.log.levels.WARN
        )
        break
    end
    vim.keymap.set({ 'x', 'o' }, 'af', function()
        treesitter_to.select_textobject('@function.outer', 'textobjects')
    end, { desc = 'function outer text object' })
    vim.keymap.set({ 'x', 'o' }, 'if', function()
        treesitter_to.select_textobject('@function.inner', 'textobjects')
    end, { desc = 'function inner text object' })
    vim.keymap.set({ 'x', 'o' }, 'aa', function()
        treesitter_to.select_textobject('@parameter.outer', 'textobjects')
    end, { desc = 'parameter outer text object' })
    vim.keymap.set({ 'x', 'o' }, 'ia', function()
        treesitter_to.select_textobject('@parameter.inner', 'textobjects')
    end, { desc = 'parameter inner text object' })
until true

repeat
    local aerial = lib.try_require('aerial')
    if aerial == nil then
        vim.notify('Ignoring keybinds using aerial', vim.log.levels.WARN)
        break
    end
    vim.keymap.set(
        'n',
        '<leader>a',
        '<cmd>AerialToggle!<CR>',
        { desc = 'toggle aerial code map' }
    )
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
            end, {
                buffer = ev.buf,
                desc = 'quickly run this ' .. ft .. ' buffer',
            })
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
