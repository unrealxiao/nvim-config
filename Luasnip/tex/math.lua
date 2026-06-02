
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

-- function for generating any n by m matrix

local generate_matrix = function(_, parent)
    -- Extract rows (m) and columns (n) from the regex capture groups
    -- Example: "mat3x2" -> captures[1] = "3", captures[2] = "2"
    local rows = tonumber(parent.snippet.captures[1]) or 2
    local cols = tonumber(parent.snippet.captures[2]) or 2

    local nodes = {}
    local index = 1

    -- Loop to generate the matrix body grid
    for r = 1, rows do
        for co = 1, cols do
            if co == 1 then
              table.insert(nodes, t("  "))
            end
            -- Create an editable insert node for each cell entry
            table.insert(nodes, i(index, string.format("a_{%d%d}", r, co)))
            index = index + 1

            -- Column separator: Add " & " if it's not the last element in the row
            if co < cols then
                table.insert(nodes, t(" & "))
            end
        end

        -- Row separator: Add " \\ " (escaped as "\\\\") if it's not the last row
        if r < rows then
        table.insert(nodes, t({" \\\\ ", ""}))
        end
    end

    -- Wrap the final node grid array into a SnippetNode context
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
  -- subset symbol
  s(
    {trig = "sub", dscr = "⊂ symbol"},
    {
      t("\\subset"),
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
  --epsilon
  s(
    {trig = "eps", dscr = "ϵ symbol"},
    {
      t("\\epsilon"),
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
    {trig = "6", dscr = "∧ symbol"},
    {
      t("^{"), i(1), t("}"),
      i(0)
    }
  ),
  -- product symbol 
  s(
    {trig = "prd", dscr = "Π symbol"},
    {
      t("\\Pi"),
      i(0)
    }
  ),
  -- sum symbol
  s(
    {trig = "sum", dscr = "Σ symbol"},
    {
      t("\\Sigma"),
      i(0)
    }
  ),
  -- subscript
  s(
    {trig = "-", dscr = "subscript symbol"},
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
    {trig = "mac", dscr = "captital letter, used for special accent"},
    {
      t("\\mathcal{"), i(1, "C"), t("}"),
      i(0)
    }
  ),
  -- math bm bold letters
  s(
    {trig = "bm", dscr = "bold letter"},
    {
      t("\\bm{"), i(1, "C"), t("}"),
      i(0)
    }
  ),
  -- matrix generation
  s({
        trig = "mat(%d)x(%d)",
        regTrig = true,
        wordTrig = false,
        dscr = "Generates a completely dynamic m by n LaTeX matrix environment"
    },
    {
        -- Begin the standard LaTeX math environment block
        t({ "\\begin{bmatrix}", ""}),
        -- Hook up the dynamic node to evaluate the grid dimensions
        t(""), d(1, generate_matrix),
        -- Close the environment block
        t({"", "\\end{bmatrix}" }),
        -- Absolute final jump point out of the matrix expression
        i(0)
    }
  ),
  -- not equal symbol
  s(
    {trig = "ne", dscr = "not equal symbol"},
    {
      t("\\neq"),
      i(0)
    }
  ),
}
