local command = require('utils.command')
local au = require('utils.au')
local help_popup = require('utils.misc').help_popup

command.Json = 'set filetype=json'
command(
    { '-bang', '-nargs=1', '-complete=file' },
    'Rename',
    {        '<q-args>', '<bang>0' },
    function(new_name,    bang)
        local this_file = vim.fn.expand('%')
        local savecmd = 'saveas'..(bang == 0 and '' or '!')..' '..new_name
        vim.cmd(savecmd)
        os.remove(this_file)
    end
)

nnoremap('<F1>', function()
    help_popup('Himalaya keybinds', {
        gm = 'Change the current mbox',
        gp = 'Show previous page',
        gn = 'Show next page',
        ['<Enter>'] = 'Read focused msg',
        gw = 'Write a new msg',
        gr = 'Reply to the focused msg',
        gR = 'Reply all to the focused msg',
        gf = 'Forward the focused message',
        ga = 'Download attachments from focused message',
        gC = 'Copy the focused message',
        gM = 'Move the focused message',
        gD = 'Delete the focused message(s)',
    })
end,
{ ft = 'himalaya-msg-list', buffer = true })
