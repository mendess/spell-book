local base_ls = {
    'efm',
    'lua-language-server',
    'stylua',
    'shfmt',
    'black',
    'fixjson',
    'shellcheck',
    'tree-sitter-cli',
    'bash-language-server',
}

local dev_machine_ls = vim.list_extend({
    'fixjson',
    'luacheck',
    'pyright',
    'rust-analyzer',
}, base_ls)

local server_machine_ls = vim.list_extend({
    'docker-language-server',
}, base_ls)

local work_machine_ls = vim.list_extend({
    'oxfmt',
    'oxlint',
    'typescript-language-server',
    'revive', -- go
    'gofumpt', -- go
    'prettier_d',
    'eslint_d',
}, dev_machine_ls)

local bin_translate = {
    ['efm'] = 'efm-langserver',
    ['tree-sitter-cli'] = 'tree-sitter',
    ['prettier_d'] = 'prettierd',
}

local host_based_ls = {
    ['3QWP3T3'] = work_machine_ls,
    ['pendrellvale'] = server_machine_ls,
    ['tolaria'] = dev_machine_ls,
    ['weatherlight'] = dev_machine_ls,
}

local lss = host_based_ls[vim.fn.hostname()]
if lss ~= nil then
    for _, ls in ipairs(lss) do
        if vim.fn.executable(bin_translate[ls] or ls) == 0 then
            vim.cmd(string.format('MasonInstall %s', ls))
        end
    end
end
