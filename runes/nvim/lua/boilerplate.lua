local group = vim.api.nvim_create_augroup('user-boilerplate', { clear = true })

local function append_lines(...)
    for i, l in ipairs({ ... }) do
        local text
        local cur = false
        if type(l) == 'string' then
            text = l
        else
            text = l[1]
            cur = true
        end
        vim.fn.append(i - 1, text)
        if cur then
            vim.fn.cursor(i, 1)
        end
    end
end

local run_checked = function(boil)
    return function()
        if vim.fn.line('$') == 1 and vim.fn.getline(1) == '' then
            if type(boil) == 'function' then
                boil()
            else
                if _VERSION == 'Lua 5.1' then
                    ---@diagnostic disable-next-line: deprecated
                    append_lines(unpack(boil))
                else
                    append_lines(table.unpack(boil))
                end
            end
        end
    end
end

local boilerplate_header = function()
    local guard = vim.fn.expand('%:r'):gsub('([A-Z])', '_%1'):upper()
    append_lines(
        '#ifndef ' .. guard .. '_H',
        '#define ' .. guard .. '_H',
        { '' },
        '#endif'
    )
end

local function setup_boilerplate(table)
    for _, spec in ipairs(table) do
        vim.api.nvim_create_autocmd('FileType', {
            group = group,
            pattern = spec.pattern,
            callback = run_checked(spec.boil),
        })
    end
end

setup_boilerplate({
    {
        pattern = 'c',
        boil = function()
            local ext = vim.fn.expand('%:e')
            if ext == 'h' or ext == 'hpp' then
                boilerplate_header()
            else
                append_lines(
                    '#include <stdio.h>',
                    '#include <stdlib.h>',
                    '',
                    'int main(int argc, char** argv){',
                    { '    printf("Hello world\\n");' },
                    '}'
                )
            end
        end,
    },
    {
        pattern = 'cpp',
        boil = function()
            local ext = vim.fn.expand('%:e')
            if ext == 'h' or ext == 'hpp' then
                boilerplate_header()
            else
                append_lines(
                    '#include <iostream>',
                    '#include <vector>',
                    '#include <string>',
                    '',
                    'auto main(int argc, char** argv) -> int {',
                    { '    std::cout << "Hello world" << std::endl;' },
                    '}'
                )
            end
        end,
    },
    {
        pattern = 'java',
        boil = {
            'import java.util.*;',
            '',
            'public class ' .. vim.fn.expand('%:t:r') .. ' {',
            '    public static void main(String[] args) throws Exception {',
            { '        System.out.println("Hello world");' },
            '    }',
            '}',
        },
    },
    {
        pattern = 'html',
        boil = {
            '<!DOCTYPE html>',
            '<html>',
            '  <head>',
            '    <title>' .. vim.fn.expand('%:r') .. '</title>',
            '  </head>',
            '  <body>',
            { '' },
            '  </body>',
            '</html>',
        },
    },
    {
        pattern = 'kotlin',
        boil = {
            'fun main() {',
            { '    println("Hello world")' },
            '}',
        },
    },
    {
        pattern = 'sh',
        boil = {
            '#!/usr/bin/env bash',
            '',
            'set -euo pipefail',
            '',
        },
    },
})
