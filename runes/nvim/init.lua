local function load_mapx()
    local function f()
        return require'mapx'.setup { global = true, whichKey = true }
    end
    local ok, m = pcall(f)
    if ok then
	mapx = m
    end
end

load_mapx()
vim.g.mapleader = ' '

require('plugins')
if not mapx then load_mapx() end
require('theme')
require('behaviour')
require('writing')
require('writing-code')
require('keybindings')
require('boilerplate')
require('navigation')
require('tools')
