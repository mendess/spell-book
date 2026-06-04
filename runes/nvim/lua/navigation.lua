-- split navigations
vim.keymap.set('n', "<C-j>", "<C-W>j", { noremap = true })
vim.keymap.set('n', "<C-k>", "<C-W>k", { noremap = true })
vim.keymap.set('n', "<C-l>", "<C-W>l", { noremap = true })
vim.keymap.set('n', "<C-h>", "<C-W>h", { noremap = true })

vim.keymap.set('n', "<M-h>", "<C-w>H", { noremap = true })
vim.keymap.set('n', "<M-j>", "<C-w>J", { noremap = true })
vim.keymap.set('n', "<M-k>", "<C-w>K", { noremap = true })
vim.keymap.set('n', "<M-l>", "<C-w>L", { noremap = true })

-- split resize
vim.keymap.set('n', "<M-K>", "<C-w>+", { noremap = true })
vim.keymap.set('n', "<M-J>", "<C-w>-", { noremap = true })
vim.keymap.set('n', "<M-H>", "<C-w><", { noremap = true })
vim.keymap.set('n', "<M-L>", "<C-w>>", { noremap = true })

-- Fix Y
vim.keymap.set('n', "Y", "y$", { noremap = true })

-- alt tab
vim.keymap.set('n', '<leader><Tab>', '<C-^>', { noremap = true })

-- confy quit
vim.keymap.set('n', '<C-q>', ':q<CR>', { noremap = true })

-- terminal esq
vim.keymap.set('t', '<Esq>', [[<C-\><C-n>]], { noremap = true })
vim.keymap.set('t', '<A-[>', '<Esq>', { noremap = true })

-- jump to marker
vim.keymap.set('n', '<A-1>', '1gt', { noremap = true })
vim.keymap.set('n', '<A-2>', '2gt', { noremap = true })
vim.keymap.set('n', '<A-3>', '3gt', { noremap = true })
vim.keymap.set('n', '<A-4>', '4gt', { noremap = true })
vim.keymap.set('n', '<A-5>', '5gt', { noremap = true })
vim.keymap.set('n', '<A-6>', '6gt', { noremap = true })
vim.keymap.set('n', '<A-7>', '7gt', { noremap = true })
vim.keymap.set('n', '<A-8>', '8gt', { noremap = true })
vim.keymap.set('n', '<A-9>', '9gt', { noremap = true })

-- easier start and end
vim.keymap.set('n', 'H', '^', { noremap = true })
vim.keymap.set('n', 'L', '$', { noremap = true })
