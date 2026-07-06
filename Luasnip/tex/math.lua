
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local sn = ls.snippet_node
local d = ls.dynamic_node
local r = ls.restore_node

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
            table.insert(nodes, i(index, ""))
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
  --single ordinary integral
  s(
    {trig = "itg", dscr = "single integral symbol"},
    {
      t("\\int_{"), i(1), t("}^{"), i(2), t("} "),
      i(3, "f"), t("\\; d"), i(4, "x"),
      i(0),
    }
  ),

  --partial derivative symbol
  s(
    {trig = "prt", dscr = "∂ symbol"},
    {
      t("\\partial"),
      i(0)
    }
  ),
  --partial derivative fraction
  s(
    {trig = "prf", dscr = "partial derivative fraction"},
    {
      t("\\frac{\\partial "), i(1), t("}{\\partial "), i(2), t("}"),
      i(0)
    }
  ),
  --ordinary derivative fraction
  s(
    {trig = "odf", dscr = "ordinary derivative fraction"},
    {
      t("\\frac{d "), i(1), t("}{d "), i(2), t("}"),
      i(0)
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
  --not belong to symbol
  s(
    {trig = "nbe", dscr = "∉ symbol"},
    {
      t("\\notin"),
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
  -- subset equal symbol
  s(
    {trig = "sue", dscr = "⊆ symbol"},
    {
      t("\\subseteq"),
      i(0)
    }
  ),
  -- superset 
  s(
    {trig = "sup", dscr = "⊃ symbol"},
    {
      t("\\supset"),
      i(0)
    }
  ),
  -- superset or equal
  s(
    {trig = "spe", dscr = "⊇ symbol"},
    {
      t("\\supseteq"),
      i(0)
    }
  ),
  -- union
  s(
    {trig = "uni", dscr = "union symbol"}, {c(
      1,
      {
        sn(nil, {t("\\cup"), i(1), i(0)}),
        sn(nil, {t("\\bigcup_{"), i(1), t("}^{"), i(2), t("}"), i(0)}),
      }
    ),
    }
  ),
  -- intersect
  s(
    {trig = "int", dscr = "intersect symbol"}, {c(
      1,
      {
        sn(nil, {t("\\cap"), i(1), i(0)}),
        sn(nil, {t("\\bigcap_{"), i(1), t("}^{"), i(2), t("}"), i(0)}),
      }
    ),
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
      t("\\ge"),
      i(0)
    }
  ),
  -- triple equal
  s(
    {trig = "tre", dscr = "≡ symbol"},
    {
      t("\\equiv"),
      i(0)
    }
  ),
  --alpha
  s(
    {trig = "alp", dscr = "α symbol"},
    {
      t("\\alpha"),
      i(0)
    }
  ),
  --beta
  s(
    {trig = "bet", dscr = "β symbol"},
    {
      t("\\beta"),
      i(0)
    }
  ),
  --theta
  s(
    {trig = "the", dscr = "θ symbol"},
    {
      t("\\theta"),
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
  -- mu
  s(
    {trig = "mu", dscr = "μ symbol"},
    {
      t("\\mu"),
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
  --delta
  s(
    {trig = "del", dscr = "δ symbol"},
    {
      t("\\delta"),
      i(0)
    }
  ),
  --nabla
  s(
    {trig = "nab", dscr = "∇ symbol"},
    {
      t("\\nabla"),
      i(0)
    }
  ),
  --phi variant
  s(
    {trig = "ph", dscr = "φ symbol"},
    {
      t("\\varphi"),
      i(0)
    }
  ),
  --sin operator
  s(
    {trig = "sin", dscr = "sin operator"},
    {
      t("\\sin"),
      i(0)
    }
  ),
  --cos operator
  s(
    {trig = "cos", dscr = "cos operator"},
    {
      t("\\cos"),

      i(0)
    }
  ),
  --tan operator
  s(
    {trig = "tan", dscr = "tan operator"},
    {
      t("\\tan"),
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
  -- uniform convergence arrow
  s(
    {trig = "dra", dscr = "double right arrow symbol"},
    {
      t("\\rightrightarrows"),
      i(0)
    }
  ),
  -- long right arrow
  s(
    {trig = "lra", dscr = "long right arrow symbol"},
    {
      t("\\longrightarrow"),
      i(0)
    }
  ),
  -- fraction
  s(
    {trig = "fra", dscr = "fraction symbol"},
    {c(1,{
        sn(nil, {t("\\dfrac{"), i(1), t("}{"), i(2), t("}"), i(0)}),
        sn(nil, {t("\\frac{"), i(1), t("}{"), i(2), t("}"), i(0)})
    })
    }
  ),
  -- limit
  s(
    {trig = "lim", dscr = "limit symbol"},
    {
      t("\\lim_{"), i(1), t("}"),
      i(0)
    }
  ),
  -- infinity
  s(
    {trig = "inf", dscr = "∞ symbol"},
    {
      t("\\infty"),
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
      t("\\sum_{"), i(1, "sub"), t("}^{"), i(2, "sup"), t("}"),
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
  -- isomorphic symbol
  s(
    {trig = "iso", dscr = "≅ symbol"},
    {
      t("\\cong"),
      i(0)
    }
  ),
  -- direct sum symbol
  s(
    {trig = "drs", dscr = "⨁ symbol"},
    {
      t("\\oplus"),
      i(0)
    }
  ),
  -- dot product
  s(
    {trig = "dot", dscr = "dot product symbol"},
    {
      t("\\cdot"),
      i(0)
    }
  ),
  -- cross product
  s(
    {trig = "cro", dscr = "× symbol"},
    {
      t("\\times"),
      i(0)
    }
  ),
  -- square root symbol
  s(
    {trig = "sqr", dscr = "√ symbol"},
    {
      t("\\sqrt{"), i(1, "content"), t("}"),
      i(0)
    }
  ),
  -- gcd 
  s(
    {trig = "gcd", dscr = "greatest common divisor"},
    {
      t("\\gcd("), i(1, "a"), t(","), i(2, "b"), t(")"),
      i(0)
    }
  ),
  -- mod
  s(
    {trig = "mod", dscr = "modular operator"},
    {
      t("\\mod"),
      i(0)
    }
  ),
  -- kernel 
  s(
    {trig = "ker", dscr = "kernel"},
    {
      t("\\ker"),
      i(0)
    }
  ),
  -- image 
  s(
    {trig = "img", dscr = "image"},
    {
      t("\\Ima"),
      i(0)
    }
  ),
  --minimum 
  s(
    {trig = "min", dscr = "minimum"},
    {
      t("\\min"),
      i(0)
    }
  ),
  --maximum 
  s(
    {trig = "max", dscr = "maximum"},
    {
      t("\\max"),
      i(0)
    }
  ),
}
