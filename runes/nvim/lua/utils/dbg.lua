local function print_table(t)

    local function printTableHelper(obj, cnt)
        local cnt = cnt or 0
        local s = ""
        if type(obj) == "table" then
            s = s .. "\n" .. string.rep("\t", cnt) .. "{\n"
            cnt = cnt + 1
            for k,v in pairs(obj) do
                if type(k) == "string" then
                    s = s .. string.rep("\t",cnt) .. '["'..k..'"]' .. ' = '
                elseif type(k) == "number" then
                    s = s .. string.rep("\t",cnt) .. "["..k.."]" .. " = "
                end
                s = s .. printTableHelper(v, cnt) .. ",\n"
            end
            cnt = cnt-1
            s = s .. string.rep("\t", cnt) .. "}"

        elseif type(obj) == "string" then
            s = s .. string.format("%q", obj)
        else
            s = s .. tostring(obj)
        end
        return s
    end

    return printTableHelper(t)
end

local function dbg(x)
    local file = io.open('dbg', 'a')
    if file == nil then
        print("failed to open dbg")
        return x
    end
    if type(x) == "table" then
        file:write(print_table(x))
    else
        file:write(tostring(x).."\n")
    end
    file:flush()
    return x
end

return dbg
