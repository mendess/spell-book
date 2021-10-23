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


return M
