return {
    try_require = function(name)
        local ok, result = pcall(require, name)
        if ok then
            return result
        end
        -- Only suppress genuine "module not found" errors
        if
            type(result) == 'string'
            and result:find("module '" .. name .. "' not found", 1, true)
        then
            return nil
        end
        -- Re-raise syntax/runtime/dependency errors
        error(result, 2)
    end,
}
