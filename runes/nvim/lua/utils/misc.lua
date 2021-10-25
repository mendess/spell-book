local M = {}

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

return M
