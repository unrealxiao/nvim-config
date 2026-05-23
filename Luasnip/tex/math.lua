
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local sn = ls.snippet_node
local d = ls.dynamic_node

-- function for multi integral
local generate_integrals = function(args)
    local dim = tonumber(args[1][1]) or 0
    local exit_index = 3
    local nodes = {}

    if dim < 1 then
        return sn(nil, { i(1, "\\int") })
    end

    -- Create sequential \int symbols
    table.insert(nodes, t("\\" .. string.rep("i", dim) .. "nt"))

    -- Add a subscript/bound input field to the final integral symbol
    table.insert(nodes, t("_{"))
    table.insert(nodes, i(1, "V")) -- This is the integration domain (e.g., V, \Omega)
    table.insert(nodes, t("} "))

    -- Add the core integrand input field
    table.insert(nodes, i(2, "f(x)"))
    -- Automatically generates differential variables.
    for j = 1, dim do
      table.insert(nodes, t("\\,d{"))
      table.insert(nodes, i(exit_index, "x"))
      table.insert(nodes, t("}"))
    exit_index = exit_index + 1
    end

    return sn(nil, nodes)
end

-- function for multiple countour integral

local countour_integrals = function(args)
    local dim = tonumber(args[1][1]) or 0
    local exit_index = 3
    local nodes = {}

    if dim < 1 then
        return sn(nil, { i(1, "\\oint") })
    end

    -- Create sequential \int symbols
    table.insert(nodes, t("\\o" .. string.rep("i", dim) .. "nt"))

    -- Add a subscript/bound input field to the final integral symbol
    table.insert(nodes, t("_{"))
    table.insert(nodes, i(1, "V")) -- This is the integration domain (e.g., V, \Omega)
    table.insert(nodes, t("} "))

    -- Add the core integrand input field
    table.insert(nodes, i(2, "f(x)"))
    -- Automatically generates differential variables.
    for j = 1, dim do
      table.insert(nodes, t("\\,d{"))
      table.insert(nodes, i(exit_index, "x"))
      table.insert(nodes, t("}"))
    exit_index = exit_index + 1
    end

    return sn(nil, nodes)
end

return{
  --integral and multi integral
  s(
    "int",
    {
      t("Dim: "), i(1, "2"), t({"", ""}),
      d(2, generate_integrals, {1}),
      i(0)
    }
  ),
  s(
    "oint",
    {
      t("Dim: "), i(1, "2"), t({"", ""}),
      d(2, countour_integrals, {1}),
      i(0)
    }
  ),
}
