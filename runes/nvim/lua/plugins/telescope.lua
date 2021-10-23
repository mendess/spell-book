local actions = require('telescope.actions')
local t = require('telescope.builtin')
local au = require('utils.au');
local command = require('utils.command')

mapx.group({ silent = true }, function()
    nnoremap('<leader>p', function() t.find_files() end)
    nnoremap('<leader>b', t.buffers)
    command.Rg = t.grep_string
end)

require('telescope').setup {
    defaults = {
        mappings = {
            n = {
                ["q"] = actions.close
            },
            i = {
                ["<C-d>"] = actions.close
            }
        }
    }
}

-- au.group('telescope', function(g)
--     g.FileType = {
--         'TelescopePrompt',
--         function()
--             vim.cmd [[
--             augroup! number-toggle
--             set nonumber norelativenumber
--             ]]
--         end
--     }
-- end)
