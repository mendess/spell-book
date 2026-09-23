-- Loader for bassamsdata's MiniFiles git integration gist.
-- Downloads the pinned revision on first run; skips if curl is missing or
-- download fails. The file is executed with load() after stripping the
-- trailing "end," that the gist expects from a lazy.nvim config wrapper.

local REVISION = 'db74ab640b23c4f68874b51aa63c7ffb6b8284ae'
local URL = ('https://gist.githubusercontent.com/bassamsdata/%s/raw/%s/minifiles.lua'):format(
    'eec0a3065152226581f8d4244cce9051',
    REVISION
)

local vendor_dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'vendor')
local dest = vim.fs.joinpath(
    vendor_dir,
    'minifiles_git_' .. REVISION:sub(1, 8) .. '.lua'
)

local function load_vendor()
    local f = io.open(dest, 'r')
    if not f then
        return false
    end
    local source = f:read('*a')
    f:close()

    -- The gist ends with "end," closing a lazy.nvim config block.
    -- Strip it so the code is valid standalone Lua.
    source = source:gsub('%s*end,%s*$', '')

    local chunk, err = load(source, '@' .. dest)
    if not chunk then
        vim.notify('minifiles_git: load error: ' .. err, vim.log.levels.WARN)
        return false
    end
    local ok, run_err = pcall(chunk)
    if not ok then
        vim.notify(
            'minifiles_git: runtime error: ' .. run_err,
            vim.log.levels.WARN
        )
        return false
    end
    return true
end

local function download()
    if vim.fn.executable('curl') ~= 1 then
        return
    end
    vim.fn.mkdir(vendor_dir, 'p')
    local tmp = dest .. '.tmp'
    vim.notify(
        'minifiles_git: downloading pseudo plugin minifiles_git',
        vim.log.levels.INFO
    )
    vim.system(
        { 'curl', '-fsSL', '-o', tmp, URL },
        { text = false },
        function(result)
            if result.code ~= 0 then
                vim.notify(
                    'minifiles_git: download failed (exit '
                        .. result.code
                        .. ')',
                    vim.log.levels.WARN
                )
                pcall(os.remove, tmp)
                return
            end
            -- Atomic rename so a partial download is never loaded.
            local ok = vim.uv.fs_rename(tmp, dest)
            if ok then
                vim.notify(
                    'minifiles_git: downloaded, will activate on next startup',
                    vim.log.levels.INFO
                )
            else
                vim.notify(
                    'minifiles_git: failed to save file',
                    vim.log.levels.WARN
                )
                pcall(os.remove, tmp)
            end
        end
    )
end

return {
    setup = function()
        if not load_vendor() then
            download()
        end
    end,
}
