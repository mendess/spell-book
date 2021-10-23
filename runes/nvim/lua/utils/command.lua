local function fn_or_expr(t)
    return type(t) == 'function' or type(t) == 'string'
end

local function assert_type(value, ...)
    local tys = {...}
    local v_ty = type(value)
    for _, t in ipairs(tys) do
        if t == v_ty then return end
    end
    error('expected ' .. table.concat(tys, ' or ') .. ', found ' .. vty)
end

-- OVERLOAD 1
-- sort_args(name   ,      action                                  )
-- sort_args(string ,      function|string                         )
--
-- OVERLOAD 2
-- sort_args(options,      name  ,         action                  )
-- sort_args(table  ,      string,         function|string         )
--
-- OVERLOAD 3
-- sort_args(options,      name,           arguments,      action  )
-- sort_args(table  ,      string,         table,          function)
--
-- returns name, action, options?, arguments?

local function sort_args(fst, snd, thr, fth)
    if type(fst) == 'string' then
        assert_type(snd, 'function', 'string')
        if thr ~= nil or fth ~= nil then
            error('arguments after command action are ignored')
        end
        return fst, snd, nil, nil -- OVERLOAD 1
    end

    assert_type(fst, 'table') -- fst : table
    assert_type(snd, 'string') -- snd : string

    if fn_or_expr(thr) then
        -- thr : function | string
        if fth ~= nil then
            error('arguments after command action are ignored')
        end
        return snd, thr, fst, nil -- OVERLOAD 2
    elseif type(thr) == 'table' then
        -- thr: table
        assert_type(fth, 'function')
        -- fth: function
        return snd, fth, fst, thr
    else
        error('expected string or function or table, found ' .. type(thr))
    end
end

local function command(this, a, b, c, d)
    local name, action, options, arguments = sort_args(a, b, c, d)

    options = options ~= nil and table.concat(options, ' ') .. ' ' or ''
    if type(action) == 'function' then
        action = this.set(action, arguments)
    end
    vim.cmd('command! ' .. options .. name .. ' ' .. action)
end

local S = {
    __au = {},
}

local X = setmetatable({}, {
    __index = S,
    __call = command,
    __newindex = command,
})

function S.exec(id, ...)
    S.__au[id](...)
end

function S.set(fn, arguments)
    local id = string.format('%p', fn)
    S.__au[id] = fn
    local args
    if arguments then
        args = ',' .. table.concat(arguments, ',')
    else
        args = ''
    end
    return string.format(
        'lua require("utils.command").exec("%s"%s)',
        id,
        args
    )
end

return X
