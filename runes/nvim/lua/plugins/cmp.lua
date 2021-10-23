local set = vim.opt

set.completeopt = {'menu', 'menuone', 'noselect', 'preview'}

local cmp = require('cmp')

cmp.setup {
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = "path" },
        { name = "luasnip" },
        { name = 'buffer' },
    }
}
