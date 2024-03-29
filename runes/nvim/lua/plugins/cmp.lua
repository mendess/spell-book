local set = vim.opt

set.completeopt = {'menu', 'menuone', 'noselect', 'preview', 'noinsert'}

local cmp = require('cmp')

cmp.setup {
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ['<C-Space>'] = cmp.mapping.complete(),
        -- ['<CR>'] = cmp.mapping.confirm({
        --     behavior = cmp.ConfirmBehavior.Insert,
        --     select = true,
        -- }),
        ['<C-Y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-U>'] = cmp.mapping.confirm({ select = true }),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-N>'] = cmp.mapping.select_next_item(),
        ['<C-P>'] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = "path" },
        { name = "luasnip" },
        { name = 'buffer' },
        { name = 'emoji' },
    }
}
