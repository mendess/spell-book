-- split navigations
nnoremap("<C-j>", "<C-W>j")
nnoremap("<C-k>", "<C-W>k")
nnoremap("<C-l>", "<C-W>l")
nnoremap("<C-h>", "<C-W>h")

nnoremap("<M-h>", "<C-w>H")
nnoremap("<M-j>", "<C-w>J")
nnoremap("<M-k>", "<C-w>K")
nnoremap("<M-l>", "<C-w>L")

-- split resize
nnoremap("<M-K>", "<C-w>+")
nnoremap("<M-J>", "<C-w>-")
nnoremap("<M-H>", "<C-w><")
nnoremap("<M-L>", "<C-w>>")

-- Fix Y
nnoremap("Y", "y$")

-- alt tab
nnoremap('<leader><Tab>', '<C-^>')

-- confy quit
nnoremap('<C-q>', ':q<CR>')

-- terminal esq
tnoremap('<Esq>', [[<C-\><C-n>]])
tnoremap('<A-[>', '<Esq>')

-- jump to marker
nnoremap('<A-1>', '1gt')
nnoremap('<A-2>', '2gt')
nnoremap('<A-3>', '3gt')
nnoremap('<A-4>', '4gt')
nnoremap('<A-5>', '5gt')
nnoremap('<A-6>', '6gt')
nnoremap('<A-7>', '7gt')
nnoremap('<A-8>', '8gt')
nnoremap('<A-9>', '9gt')

-- easier start and end
nnoremap('H', '^')
nnoremap('L', '$')
