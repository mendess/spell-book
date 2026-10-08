local buf_path = vim.api.nvim_buf_get_name(0)
if buf_path == '' then
    return
end
local cfg = vim.fs.find(
    { 'rustfmt.toml', '.rustfmt.toml' },
    { path = vim.fs.dirname(buf_path), upward = true, type = 'file' }
)[1]
local max_width = 100 -- rustfmt default
if cfg then
    for line in io.lines(cfg) do
        local value = line:match('^%s*max_width%s*=%s*(%d+)')
        if value then
            max_width = tonumber(value) or max_width
            break
        end
    end
end
local prev = vim.wo.colorcolumn
vim.opt_local.colorcolumn = tostring(max_width + 1)

local undo = vim.b.undo_ftplugin
vim.b.undo_ftplugin = (undo and undo .. ' | ' or '')
    .. 'let &l:colorcolumn = '
    .. vim.fn.string(prev)
