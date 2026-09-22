local command_abbreviations = {
    Wq = 'wq',
    WQ = 'wq',
    W = 'w',
    Q = 'q',
    Qa = 'qa',
}

for left, right in pairs(command_abbreviations) do
    vim.cmd(
        ('cnoreabbrev <expr> %s getcmdtype()==":"&&getcmdline()=="%s"?"%s":"%s"'):format(
            left,
            left,
            right,
            left
        )
    )
end

vim.api.nvim_create_user_command('Rename', function(opts)
    local old_path = vim.fn.expand('%:p')
    if old_path == '' then
        vim.notify('Buffer has no file', vim.log.levels.ERROR)
        return
    end
    local new_path = vim.fn.fnamemodify(opts.args, ':p')
    vim.api.nvim_cmd({
        cmd = 'saveas',
        bang = opts.bang,
        args = { vim.fn.fnameescape(new_path) },
    }, {})
    local ok, err = vim.uv.fs_unlink(old_path)
    if not ok then
        vim.notify(
            'Failed to delete old file: ' .. tostring(err),
            vim.log.levels.WARN
        )
    end
end, { nargs = 1, bang = true, complete = 'file' })

local function non_active_plugins()
    return vim.iter(vim.pack.get())
        :filter(function(x)
            return not x.active
        end)
        :map(function(x)
            return x.spec.name
        end)
        :totable()
end

vim.api.nvim_create_user_command('PackDel', function(opts)
    if opts.args:match('%S') then
        vim.pack.del(opts.fargs)
    else
        vim.pack.del(non_active_plugins())
    end
end, { nargs = '*', desc = 'delete plugin' })

vim.api.nvim_create_user_command('PackUpdate', function(opts)
    -- checks if any argument is passed
    if opts.args:match('%S') then
        -- update specific plugins
        local plugins = vim.split(opts.args, '%s+', { trimempty = true })
        -- update only specified plugins
        vim.pack.update(plugins)
    else
        -- update all
        vim.pack.update()
    end
end, { nargs = '*', desc = 'Update all plugins or specific ones' })

vim.api.nvim_create_user_command('PackCheck', function()
    local non_active = non_active_plugins()

    if #non_active == 0 then
        vim.notify('🆗 No non-active plugins found!', vim.log.levels.INFO)
        return
    end
    for _, plugin in ipairs(non_active) do
        vim.notify('Non-active plugin: ' .. plugin, vim.log.levels.WARN)
    end
end, { desc = 'Check for non active plugins' })
