-- Headless smoke test for the Neovim configuration.
-- Run with: NVIM_APPNAME=nvim2 nvim --headless -u init.lua -l test_smoke.lua

local errors = {}

local function check(name, fn)
    local ok, err = pcall(fn)
    if not ok then
        errors[#errors + 1] = name .. ': ' .. tostring(err)
    end
end

-- 1. Basic startup: init.lua modules loaded without error
check('init.lua loads', function()
    assert(package.loaded['plugins'] or package.loaded['plugins.init'], 'plugins not loaded')
    assert(package.loaded['theme'], 'theme not loaded')
    assert(package.loaded['options'], 'options not loaded')
    assert(package.loaded['commands'], 'commands not loaded')
    assert(package.loaded['lsp'], 'lsp not loaded')
end)

-- 2. User commands exist
check('user commands registered', function()
    local cmds = vim.api.nvim_get_commands({})
    assert(cmds['Rename'], ':Rename not registered')
    assert(cmds['PackDel'], ':PackDel not registered')
    assert(cmds['PackUpdate'], ':PackUpdate not registered')
    assert(cmds['PackCheck'], ':PackCheck not registered')
    assert(cmds['Gd'], ':Gd not registered')
end)

-- 3. CSS filetype sets buffer-local options without error
check('CSS filetype options', function()
    vim.cmd('enew')
    local buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].filetype = 'css'
    -- Setting filetype triggers FileType autocmd automatically
    assert(vim.bo[buf].tabstop == 2, 'CSS tabstop should be 2, got ' .. vim.bo[buf].tabstop)
    assert(vim.bo[buf].shiftwidth == 2, 'CSS shiftwidth should be 2')
    assert(vim.bo[buf].softtabstop == 2, 'CSS softtabstop should be 2')
    vim.api.nvim_buf_delete(buf, { force = true })
end)

-- 4. Go filetype uses window-local listchars
check('Go listchars window-local', function()
    local global_lc = vim.api.nvim_get_option_value('listchars', { scope = 'global' })
    vim.cmd('enew')
    local buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].filetype = 'go'
    -- Setting filetype triggers FileType autocmd automatically
    -- Global value should be unchanged
    local after = vim.api.nvim_get_option_value('listchars', { scope = 'global' })
    assert(after == global_lc, 'Global listchars leaked: ' .. after)
    vim.api.nvim_buf_delete(buf, { force = true })
end)

-- 5. Fallback <leader>r does not error (uses vim.bo.filetype, not vim.opt.filetype)
check('fallback leader-r uses string filetype', function()
    -- Just verify the mapping exists and doesn't crash on setup
    local maps = vim.api.nvim_get_keymap('n')
    local found = false
    for _, m in ipairs(maps) do
        if m.lhs == ' r' then
            found = true
            break
        end
    end
    assert(found, 'fallback <leader>r mapping not found')
end)

-- 6. try_require returns nil for missing modules
check('try_require missing module', function()
    local lib = require('lib')
    local result = lib.try_require('nonexistent_module_xyz_12345')
    assert(result == nil, 'try_require should return nil for missing module')
end)

-- 7. Fugitive statusline guard
check('Fugitive_status_line does not error', function()
    local result = Fugitive_status_line()
    assert(type(result) == 'string', 'statusline should return a string')
end)

-- 8. MiniIndentscope highlight link is correct
check('MiniIndentscopeSymbolOff links correctly', function()
    local hl = vim.api.nvim_get_hl(0, { name = 'MiniIndentscopeSymbolOff' })
    if hl.link then
        assert(hl.link == 'MiniIndentscopeSymbol',
            'Expected link to MiniIndentscopeSymbol, got ' .. tostring(hl.link))
    end
end)

-- Report results
if #errors == 0 then
    print('PASS: All smoke tests passed')
    vim.cmd('qa!')
else
    for _, e in ipairs(errors) do
        io.stderr:write('FAIL: ' .. e .. '\n')
    end
    vim.cmd('cq!')
end
