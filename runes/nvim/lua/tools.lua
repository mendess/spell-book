local command = require('utils.command')

command.Json = 'set filetype=json'
command(
    { '-bang', '-nargs=1', '-complete=file' },
    'Rename',
    {        '<q-args>', '<bang>0' },
    function(new_name,    bang)
        local this_file = vim.fn.expand('%')
        local savecmd = 'saveas' .. (bang == 0 and '' or '!') .. new_name
        vim.cmd(savecmd)
        os.remove(this_file)
    end
)
