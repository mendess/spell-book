local iabbrev = require('utils.misc').iabbrev
local au = require('utils.au')
local line = vim.fn.line
local getline = vim.fn.getline
local expand = vim.fn.expand
local append = vim.fn.append
local cursor = vim.fn.cursor

au.group('java-bloat', function(g)
    g.BufEnter = {
        '*.java',
        function() iabbrev('sout', 'System.out.println') end
    }
end)

au.group('boilerplate', function(g)
    local function append_lines(...)
        for i, l in ipairs({...}) do
            local text
            local cur = false
            if type(l) == 'string' then
                text = l
            else
                text = l[1]
                cur = true
            end
            append(i - 1, text)
            if cur then cursor(i, 1) end
        end
    end
    local run_checked = function(...)
        local args = {...}
        return function()
            if line('$') == 1 and getline(1) == '' then
                if type(args[1]) == 'function' then
                    args[1]()
                else
                    append_lines(unpack(args))
                end
            end
        end
    end

    local boilerplate_header = function()
        local guard = expand('%:r'):gsub('([A-Z])', '_%1'):upper()
        append_lines(
            '#ifndef '..guard..'_H',
            '#define '..guard..'_H',
            {''},
            '#endif'
        )
    end
    au.FileType = {
        'c',
        run_checked(function()
            local ext = expand('%:e')
            if ext == 'h' or ext == 'hpp' then
                boilerplate_header()
            else
                append_lines(
                    '#include <stdio.h>',
                    '#include <stdlib.h>',
                    '',
                    'int main(int argc, char** argv){',
                    {'    printf("Hello world\\n");'},
                    '}'
                )
            end
        end)
    }
    au.FileType = {
        'cpp',
        run_checked(function()
            local ext = expand('%:e')
            if ext == 'h' or ext == 'hpp' then
                boilerplate_header()
            else
                append_lines(
                    "#include <iostream>",
                    "#include <vector>",
                    "#include <string>",
                    "",
                    "auto main(int argc, char** argv) -> int {",
                    {'    std::cout << "Hello world" << std::endl;'},
                    "}"
                )
            end
        end)
    }
    au.FileType = {
        'java',
        run_checked(
            'import java.util.*;',
            '',
            'public class '..expand('%:t:r')..' {',
            '    public static void main(String[] args) throws Exception {',
            {'        System.out.println("Hello world");'},
            '    }',
            '}'
        )
    }
    au.FileType = {
        'html',
        run_checked(
             '<!DOCTYPE html>',
             '<html>',
             '  <head>',
             '    <title>'..expand('%:r')..'</title>',
             '  </head>',
             '  <body>',
             {''},
             '  </body>',
             '</html>'
        )
    }
    au.FileType = {
        'kotlin',
        run_checked(
            'fun main() {',
            {'   println("Hello world")'},
            '}'
        )
    }
end)
