local actions = require('telescope.actions')

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
