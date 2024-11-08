local M = {}

local function tmerge(dest, source)
    for k,v in pairs(source) do
        if type(v) == "table" then
            if type(dest[k] or false) == "table" then
                tmerge(dest[k] or {}, source[k] or {})
            else
                dest[k] = v
            end
        else
            dest[k] = v
        end
    end
    return dest
end

M.table_merge = function(dest, source)
    return tmerge(dest, source)
end

M.file_exists = function(name)
    local f = io.open(name, 'r')
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

M.download = function(url, where)
    local http = require('socket.http')
    local body, code = http.request(url)
    if not body then error(code) end
    local f = io.open(where, 'wb')
    if f == nil then error("can't open file") end
    f:write(body)
    f:close()
end

M.iabbrev = function(ab, full)
    vim.cmd('ia ' .. ab .. ' ' .. full)
end

M.safe_require = function(mod)
    local ok, m = pcall(require, mod)
    if ok then return m else return nil end
end

M.if_require_do = function(mod, f)
    local m = M.safe_require(mod)
    if m then
        f(m)
        return m
    else
        return nil
    end
end

M.table_len = function(t)
    local x = 0
    for _, _ in pairs(t) do
        x = x + 1
    end
    return x
end

M.help_popup = function(title, keybinds)
    title = '=== ' .. title .. ' ==='
    local last_win = vim.api.nvim_get_current_win()
    local last_pos = vim.api.nvim_win_get_cursor(last_win)
    local columns = vim.o.columns
    local lines = vim.o.lines
    local longestK = 0
    local longestV = 0
    for k, v in pairs(keybinds) do
        longestK = math.max(longestK, string.len(k))
        longestV = math.max(longestV, string.len(v))
    end
    local width = math.min(columns, math.max(longestK + longestV + string.len(' => ') + 4, string.len(title)))
    local height = math.min(math.ceil(lines * 0.8 - 4), M.table_len(keybinds) + 3 + 2)
    local left = math.ceil((columns - width) * 0.5)
    local top = math.ceil((lines - height) * 0.5 - 1)
    local opts = {
        relative = 'editor',
        style = 'minimal',
        width = width,
        height = height,
        col = left,
        row = top,
        focusable = false,
        border = 'rounded',
        noautocmd = true,
    }

    local output = {
        '',
        string.rep(' ', math.floor(width / 2) - math.floor(string.len(title) / 2) - 1) .. title,
        ''
    }
    for k, v in pairs(keybinds) do
        table.insert(output, '  ' .. k .. string.rep(' ', longestK - string.len(k)) .. ' => ' .. v)
    end
    table.insert(output, string.rep('-', width))
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_buf_set_lines(buf, 0, 1, true, output)
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q!<cr>', {silent = true})
    vim.api.nvim_buf_set_keymap(buf, 'n', '<F1>', ':q!<cr>', {silent = true})
    vim.api.nvim_win_set_cursor(win, {height - 1, width})
end

return M
