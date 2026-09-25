-- Loader for MiniFiles git integration gist (mendess fork of bassamsdata's).
-- Downloads the pinned revision on first run; skips if curl is missing or
-- download fails.

local REVISION = '893ec68c601656988c2ae83a820b1572d8abd86e'
local URL = ('https://gist.githubusercontent.com/mendess/%s/raw/%s/minifiles.lua'):format(
    '0a8215ad7f9dc4987ac4f03c394bb163',
    REVISION
)

local short_rev = function()
    return REVISION:sub(1, 8)
end

local vendor_dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'vendor')
local dest =
    vim.fs.joinpath(vendor_dir, 'minifiles_git_' .. short_rev() .. '.lua')

local function load_vendor()
    if not vim.uv.fs_stat(dest) then
        return false
    end
    local chunk, err = loadfile(dest)
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

--- Remove older vendored revisions that don't match the current REVISION.
local function cleanup_old_revisions()
    local handle = vim.uv.fs_scandir(vendor_dir)
    if not handle then
        return
    end
    local current_name = 'minifiles_git_' .. short_rev() .. '.lua'
    while true do
        local name, typ = vim.uv.fs_scandir_next(handle)
        if not name then
            break
        end
        if
            typ == 'file'
            and name ~= current_name
            and name:match('^minifiles_git_%x+%.lua$')
        then
            os.remove(vim.fs.joinpath(vendor_dir, name))
        end
    end
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
        { 'curl', '-fsS', '-o', tmp, URL },
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
        cleanup_old_revisions()
        if not load_vendor() then
            download()
        end
    end,
}
