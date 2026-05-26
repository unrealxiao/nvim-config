
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
    table.insert(nodes, t("\\,d{"))
    table.insert(nodes, i(3, "x"))
    table.insert(nodes, t("}"))

    return sn(nil, nodes)
end

-- function for multiple countour integral

local countour_integrals = function(args)
    local dim = tonumber(args[1][1]) or 0
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
    -- Add differential variables.
    table.insert(nodes, t("\\,d{"))
    table.insert(nodes, i(3, "x"))
    table.insert(nodes, t("}"))

    return sn(nil, nodes)
end

return{
  --integral and multi integral
  s(
    {trig = "int(%d)", regTrig = true, dscr = "multi dimension integral symbols"},
    {
      d(1, function (_, parent)
        local dim = tonumber(parent.snippet.trigger:match("%d")) or 1
        return generate_integrals({{tostring(dim)}})
      end),
      i(0),
    }
  ),
  s(
    {trig = "oint(%d)", regTrig = true, dscr = "multi dimension countour integral symbol"},
    {
      d(1, function (_, parent)
        local dim = tonumber(parent.snippet.trigger:match("%d")) or 1
        return countour_integrals({{tostring(dim)}})
      end),
      i(0),
    }
  ),
  --belong to symbol
  s(
    {trig = "bel", dscr = "∈ symbol"},
    {
      t("\\in"),
      i(0)
    }
  ),
  -- less equal symbol
  s(
    {trig = "lne", dscr = "<= symbol"},
    {
      t("\\le"),
      i(0)
    }
  ),
  -- greater equal
  s(
    {trig = "gne", dscr = ">= symbol"},
    {
      t("\\in"),
      i(0)
    }
  ),
  --alpha
  s(
    {trig = "alp", dscr = "alpha symbol"},
    {
      t("\\alpha"),
      i(0)
    }
  ),
  --beta
  s(
    {trig = "bet", dscr = "beta symbol"},
    {
      t("\\beta"),
      i(0)
    }
  ),
  -- lambda
  s(
    {trig = "lam", dscr = "λ symbol"},
    {
      t("\\lambda"),
      i(0)
    }
  ),
  -- Omega
  s(
    {trig = "ome", dscr = "Ω symbol"},
    {
      t("\\Omega"),
      i(0)
    }
  ),
  -- right arrow
  s(
    {trig = "ria", dscr = "right arrow symbol"},
    {
      t("\\rightarrow"),
      i(0)
    }
  ),
  -- fraction
  s(
    {trig = "fra", dscr = "fraction symbol"},
    {
      t("\\frac{"), i(1), t("}{"), i(2), t("}"),
      i(0)
    }
  ),
  -- power 
  s(
    {trig = "por", dscr = "∧ symbol"},
    {
      t("^{"), i(1), t("}"),
      i(0)
    }
  ),
  -- subscript
  s(
    {trig = "idx", dscr = "_ symbol"},
    {
      t("_{"), i(1), t("}"),
      i(0)
    }
  ),
  -- for any
  s(
    {trig = "foa", dscr = "∀ symbol"},
    {
      t("\\forall"),
      i(0)
    }
  ),
  -- exist
  s(
    {trig = "ext", dscr = "∃ symbol"},
    {
      t("\\exists"),
      i(0)
    }
  ),
  -- mathbb bold math
  s(
    {trig = "mab", dscr = "bold captital letter, used to indicate special sets"},
    {
      t("\\mathbb{"), i(1, "Z"), t("}"),
      i(0)
    }
  ),
  -- mathcal accent letters
  s(
    {trig = "mac", dscr = "bold captital letter, used for special accent"},
    {
      t("\\mathcal{"), i(1, "C"), t("}"),
      i(0)
    }
  ),
}
