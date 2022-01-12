local au = require('utils.au')
local fn = vim.fn
local expand = fn.expand
local filereadable = fn.filereadable

au.group('shellcheck', function(g)
    g.FileType = {
        'sh',
        function()
            nnoremap('<leader>s', ':sp | term shellcheck -x %<CR>')
        end
    }
end)

local function save_compile_run(ft, spec)
    nnoremap(
        '<leader>r',
        function()
            vim.cmd [[write]]
            if spec.compile then
                spec.compile()
            end
            spec.run()
        end,
        { ft = ft }
    )
end

local function path_is_absolute() return expand('%'):sub(1, 1) == '/' end

save_compile_run('c', {
    compile = function()
        if filereadable('makefile') == 1 or filereadable('Makefile') == 1 then
            vim.cmd [[make]]
        else
            vim.cmd [[make %:r]]
        end
    end,
    run = function()
        if filereadable('makefile') == 1 or filereadable('Makefile') == 1 then
            return
        end
        if path_is_absolute() then
            vim.cmd [[!%:r]]
        else
            vim.cmd [[!./%:r]]
        end
    end
})

save_compile_run('cpp', {
    compile = function()
        if filereadable('makefile') == 1 or filereadable('Makefile') == 1 then
            vim.cmd [[make]]
        else
            vim.cmd [[!clang++ -std=c++20 % -o %:r]]
        end
    end,
    run = function()
        if path_is_absolute() then
            vim.cmd [[!%:r]]
        else
            vim.cmd [[!./%:r]]
        end
    end
})

save_compile_run('rust', {
    compile = function()
        vim.cmd [[!rustc % --allow dead_code --allow unused_variables --edition 2021 -o %:r]]
    end,
    run = function()
        if path_is_absolute() then
            vim.cmd [[!%:r]]
        else
            vim.cmd [[!./%:r]]
        end
    end
})

save_compile_run('go', {
    run = function()
        vim.cmd [[!go run %]]
    end
})

save_compile_run('kotlin', {
    compile = function()
        vim.cmd [[!kotlinc -d %:h %]]
    end,
    run = function()
        local f = expand('%:t:r')
        vim.cmd("execute '!kotlin -cp %:h "..f:sub(1, 1):upper()..f:sub(2).."Kt'")
    end
})

save_compile_run('javascript', {
    run = function()
        vim.cmd [[!node %]]
    end
})

nnoremap('<leader>r', function()
    vim.cmd [[write]]
    vim.cmd("exec '!"..vim.opt.filetype:get().." %'")
end)
