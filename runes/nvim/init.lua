vim.g.mapleader = ' '
vim.g.did_load_filetypes = 1

local if_require_do = require('utils.misc').if_require_do

require('plugins')
-- rtp hack while packer bugged
vim.o.runtimepath = vim.o.runtimepath .. ',~/.local/share/nvim/site/pack/packer/start/himalaya/vim'

mapx = if_require_do('mapx', function(m) m.setup { global = true, whichKey = true } end)
if not mapx then
    print('run :PackerSync for first time setup')
    return
end

require('theme')
require('behaviour')
require('writing')
require('writing-code')
require('keybindings')
require('boilerplate')
require('navigation')
require('tools')
