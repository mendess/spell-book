vim.g.mapleader = ' '

local if_require_do = require('utils.misc').if_require_do
local function try_load_mapx()
    if mapx then return end
    mapx = if_require_do('mapx', function(m)
        m.setup { global = true, whichKey = true }
    end)
end

require('plugins')

try_load_mapx()
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
