local function reposition_signature_helper(args)
    local MiniCompletion = require('mini.completion')
    if args.data.kind ~= 'info' then
        return
    end

    local pum = vim.fn.pum_getpos()
    if pum.row == nil then
        return
    end

    local win = args.data.win_id
    local config = vim.api.nvim_win_get_config(win)

    -- Only reposition if the window was placed to the left of the pum
    local pum_right = pum.col + pum.width
    local info_col = config.col
    if type(info_col) == 'table' then
        info_col = info_col[false]
    end
    if info_col >= pum_right then
        return
    end

    local cursor = vim.fn.screenpos(0, vim.fn.line('.'), vim.fn.col('.'))
    local anchor_row = cursor.row - 1
    local padding = 2

    -- Compute how tall the window needs to be
    local desired_width = math.min(
        MiniCompletion.config.window.info.width,
        vim.o.columns - padding
    )
    config.width = desired_width
    config.relative = 'editor'
    vim.api.nvim_win_set_config(win, config)

    local text_height = vim.api.nvim_win_text_height(win, {}).all
    local desired_height =
        math.min(text_height, MiniCompletion.config.window.info.height)

    -- Only reposition above if there is enough space
    if anchor_row - padding < desired_height then
        return
    end

    config.anchor = 'SW'
    config.row = anchor_row
    config.col =
        math.max(0, math.min(pum.col, vim.o.columns - config.width - padding))
    config.height = desired_height

    vim.api.nvim_win_set_config(win, config)
end

---Get text before the cursor (e.g. `./src|` → `./src`).
---@return string
local function text_before_cursor()
    local line = vim.api.nvim_get_current_line()
    return line:sub(1, vim.fn.col('.') - 1)
end

---Find the path in a line (e.g. `open ../foo bar/` → `../foo bar/`).
---@param before string
---@return string?
local function path_at_cursor(before)
    local start
    for i = 1, #before do
        local prev = before:sub(i - 1, i - 1)
        if
            i == 1
            or prev:match('%s')
            or prev == '"'
            or prev == "'"
            or prev == '='
            or prev == '('
        then
            local rest = before:sub(i)
            if
                rest:match('^%.%./')
                or rest:match('^%./')
                or rest:match('^~/')
                or rest:match('^/')
            then
                start = i
            end
        end
    end
    return start and before:sub(start) or nil
end

---Check for a completable path (e.g. `/abc` → true, `/ab` → false).
---@param before string
---@return boolean
local function is_path_context(before)
    local path = path_at_cursor(before)
    -- Handle paths with spaces separately.
    if path and path:find(' ', 1, true) then
        return true
    end
    -- Three or more characters after a slash.
    local after_three_chars = before:match('/%S%S%S%S*$') ~= nil
    -- A slash after a path segment.
    local next_slash = before:match('/%S+/$') ~= nil
    return after_three_chars or next_slash
end

---Complete spaced paths manually; use built-in completion for `./src`.
---@return nil
local function complete_fallback()
    local before = text_before_cursor()
    local path = path_at_cursor(before)
    if path and path:find(' ', 1, true) then
        -- () captures a position, in this case the position of the last slash
        local slash = path:match('^.*()/')
        if not slash then
            return
        end
        local dir, prefix = path:sub(1, slash), path:sub(slash + 1)
        dir = dir:gsub('^~/', vim.fn.expand('~') .. '/', 1)
        local scan = vim.uv.fs_scandir(dir)
        if scan then
            ---@type { word: string }[]
            local items = {}
            while true do
                local name, kind = vim.uv.fs_scandir_next(scan)
                if not name then
                    break
                end
                if vim.startswith(name, prefix) then
                    items[#items + 1] = {
                        word = name .. (kind == 'directory' and '/' or ''),
                    }
                end
            end
            if #items > 0 then
                vim.fn.complete(vim.fn.col('.') - #prefix, items)
            end
        end
    else
        local keys = is_path_context(before) and '<C-x><C-f>' or '<C-n>'
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes(
                '<C-g><C-g>' .. keys,
                true,
                false,
                true
            ),
            'n',
            false
        )
    end
end

return {
    after = function()
        require('mini.comment').setup()
        local MiniCompletion = require('mini.completion')
        local function process_items(items, base)
            return MiniCompletion.default_process_items(items, base, {
                kind_priority = {
                    Snippet = 0,
                },
            })
        end

        MiniCompletion.setup({
            fallback_action = complete_fallback,
            lsp_completion = {
                process_items = process_items,
            },
            mappings = {
                force_twostep = '<C-Space>',
                force_fallback = '<A-Space>',
                scroll_up = '<C-d>',
                scroll_down = '<C-f>',
            },
        })

        local group = vim.api.nvim_create_augroup('user-mini', { clear = true })
        -- A slash itself is not a mini.completion trigger. Start filesystem
        -- completion after three path characters, or at the next slash.
        vim.api.nvim_create_autocmd('InsertCharPre', {
            group = group,
            callback = function(ev)
                local after = text_before_cursor() .. vim.v.char
                local path = path_at_cursor(after)
                if
                    not after:match('/%S%S%S$')
                    and not after:match('/%S+/$')
                    and not (
                        path
                        and path:find(' ', 1, true)
                        and (vim.v.char == '/' or vim.v.char:match('%S'))
                    )
                then
                    return
                end

                local win = vim.api.nvim_get_current_win()
                vim.schedule(function()
                    if
                        vim.api.nvim_win_is_valid(win)
                        and vim.api.nvim_get_current_win() == win
                        and vim.api.nvim_get_current_buf() == ev.buf
                        and text_before_cursor() == after
                        and vim.fn.mode() == 'i'
                    then
                        MiniCompletion.complete_fallback()
                    end
                end)
            end,
        })

        vim.api.nvim_create_autocmd('CompleteDone', {
            group = group,
            callback = function(ev)
                local word = vim.v.completed_item.word
                if type(word) ~= 'string' or not vim.endswith(word, '/') then
                    return
                end

                local win = vim.api.nvim_get_current_win()
                local cursor = vim.api.nvim_win_get_cursor(win)
                local directory = word:gsub('^~/', vim.fn.expand('~') .. '/', 1)
                if vim.fn.isdirectory(directory) ~= 1 then
                    local path = path_at_cursor(text_before_cursor())
                    directory = path
                            and path:gsub('^~/', vim.fn.expand('~') .. '/', 1)
                        or directory
                end
                vim.schedule(function()
                    if
                        vim.api.nvim_win_is_valid(win)
                        and vim.api.nvim_get_current_win() == win
                        and vim.api.nvim_get_current_buf() == ev.buf
                        and vim.deep_equal(
                            vim.api.nvim_win_get_cursor(win),
                            cursor
                        )
                        and vim.fn.mode() == 'i'
                        and text_before_cursor():sub(-1) == '/'
                        and vim.fn.isdirectory(directory) == 1
                    then
                        MiniCompletion.complete_fallback()
                    end
                end)
            end,
        })

        require('mini.keymap').setup()

        vim.api.nvim_create_autocmd('User', {
            pattern = {
                'MiniCompletionWindowOpen',
                'MiniCompletionWindowUpdate',
            },
            callback = reposition_signature_helper,
        })

        local MiniSnippets = require('mini.snippets')
        MiniSnippets.setup({
            snippets = {
                MiniSnippets.gen_loader.from_lang(),
            },
        })
        MiniSnippets.start_lsp_server({ match = false })
        require('mini.pairs').setup()
        -- disable auto close pair for lifetimes in rust
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'rust',
            group = group,
            callback = function(ev)
                vim.keymap.set('i', "'", "'", { buffer = ev.buf })
            end,
        })
        require('mini.surround').setup()
        require('mini.bufremove').setup()

        require('mini.cmdline').setup({
            autocomplete = {
                predicate = function(args)
                    return #args.line > 2
                end,
            },
        })

        local MiniFiles = require('mini.files')
        MiniFiles.setup({
            mappings = {
                go_in_plus = 'l',
                go_in = 'L',
            },
            windows = {
                preview = true,
                width_preview = 80,
            },
        })

        require('plugins.mini_files_git').setup()

        require('mini.icons').setup()

        local mini_indentscope = require('mini.indentscope')
        mini_indentscope.setup({
            draw = {
                delay = 0,
                animation = mini_indentscope.gen_animation.none(),
            },
            options = {
                try_as_border = true,
            },
        })

        require('mini.notify').setup()

        local MiniDiff = require('mini.diff')
        MiniDiff.setup({
            view = {
                style = 'number',
            },
            mappings = {
                apply = '',
                reset = '',
                textobject = '',
            },
        })
        vim.api.nvim_create_user_command('Gd', function()
            MiniDiff.toggle_overlay(0)
        end, { desc = 'Toggle diff overlay' })

        vim.api.nvim_create_user_command('Gn', function()
            MiniDiff.goto_hunk('next')
        end, { desc = 'Go to next hunk' })

        vim.api.nvim_create_user_command('Gp', function()
            MiniDiff.goto_hunk('prev')
        end, { desc = 'Go to previous hunk' })

        vim.api.nvim_create_user_command('Gco', function()
            local data = MiniDiff.get_buf_data(0)
            if data == nil then
                vim.notify(
                    'MiniDiff is not active in this buffer',
                    vim.log.levels.WARN
                )
                return
            end

            local cursor_line = vim.api.nvim_win_get_cursor(0)[1]

            for _, hunk in ipairs(data.hunks) do
                local first = math.max(hunk.buf_start, 1)
                local last = hunk.buf_count > 0
                        and hunk.buf_start + hunk.buf_count - 1
                    or first

                if first <= cursor_line and cursor_line <= last then
                    MiniDiff.do_hunks(0, 'reset', {
                        line_start = first,
                        line_end = last,
                    })
                    return
                end
            end

            vim.notify('No hunk under cursor', vim.log.levels.INFO)
        end, { desc = 'Reset hunk under cursor' })

        local MiniTrailspace = require('mini.trailspace')
        MiniTrailspace.setup()

        vim.api.nvim_create_autocmd('BufWritePre', {
            group = group,
            callback = function()
                MiniTrailspace.trim()
            end,
        })

        require('mini.pick').setup()

        require('mini.extra').setup()
    end,
}
