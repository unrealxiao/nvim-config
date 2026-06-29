local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local sn = ls.snippet_node
local d = ls.dynamic_node
local r = ls.restore_node
--repeat function
local function rep(args,_,_)
  return args[1][1]
end

return{
  --snipet for figure and
  -- begin{} end{} pattern
  s(
    {trig = "beg", dscr = "the begining end box"},
    {
      t({"\\begin{"}), i(1), t({"}", ""}),
      t({"  "}), i(2),
      t({"", "\\end{"}), f(rep, {1}, {}), t({"}"}),
      i(0)
    }
  ),
  -- equation section 
  s(
    {trig = "equ", dscr = "the equation box"},
    {
      t({"\\begin{equation}"}),
      t({"", "  "}), i(1),
      t({"", "\\end{equation}"}),
      i(0)
    }
  ),
  -- align section 
  s(
    {trig = "ali", dscr = "align box"},
    {
      t({"\\begin{aligned}"}),
      t({"", "  "}), i(1, "content"), t("&"), i(2, "content"), t(" \\\\"),
      t({"", "  "}), i(3, "content"), t("&"), i(4, "content"), t(" \\\\"),
      t({"", "\\end{aligned}"}),
      i(0)
    }
  ),
  -- graph section 
  s(
    {trig = "gra", dscr = "insert graph"},
    {
      t({"\\begin{figure}[htbp]"}),
      t({"", "  \\centering"}),
      t({"", "  \\includegraphics[width="}), i(1, "0.4"), t("\\textwidth]{"), i(2, "figure"), t("}"),
      t({"", "  \\caption{"}), i(3, "caption"), t("}"),
      t({"", "  \\label{"}), i(4, "figure label"), t("}"),
      t({"", "\\end{figure}"}),
      i(0)
    }
  ),
  --snipet for Definition text bloock
  s(
    {trig = "Def", dscr = "Definition zone"}, {
      t("{\\large\\bfseries Definition "), i(1, "1.1"), t("} \\\\"),
      t({"", "{\\itshape "}), i(2, "main body of the Def"), t("\\par}"),
      i(0)
    }
  ),
  --snipet for Theorem text block
  s(
    {trig = "Thm", dscr = "Theorem zone"}, {
      t("\\begin{theorembox}", ""),
      t({"", "  {\\large\\bfseries Theorem "}), i(1, "1.1"), t("} \\\\"),
      t({"", "  "}), i(2, "main body"),
      t({"", "\\end{theorembox}"}),
      i(0)
    }
  ),
  --snipet for Theorem label
  s(
    {trig = "Thml", dscr = "Labeled Theorem zone"}, {
      t("\\begin{theorembox_label}[label="), i(1, "label"), t({"]", ""}),
      t({"", "  {\\large\\bfseries "}), i(2, "theoremname"), t("} \\\\"),
      t({"", "  "}), i(3, "main body"),
      t({"", "\\end{theorembox_label}"}),
      i(0)
    }
  ),
  --snipet for Definition label
  s(
    {trig = "Defl", dscr = "Labeled Definition zone"}, {
      t("\\begin{definitionbox_label}[label="), i(1, "label"), t({"]", ""}),
      t({"", "  {\\bfseries "}), i(2, "theoremname"), t("} \\\\"),
      t({"", "  {\\itshape "}), i(3, "main body"), t("\\par}"),
      t({"", "\\end{definitionbox_label}"}),
      i(0)
    }
  ),
  --snipet for proof
  s(
    {trig = "Pf", dscr = "proof zone"}, {
      t("\\begin{leftlinebox}", ""),
      t({"", "  {\\large\\itshape Proof.  }"}), i(1, "main body"),
      t({"", "\\end{leftlinebox}"}),
      i(0)
    }
  ),
  --snipet for remark zone
  s(
    {trig = "Rem", dscr = "remark zone"}, {
      t("\\begin{remarkbox}", ""),
      t({"", "  {\\bfseries Remark.  }"}),
      i(1, "main body"),
      t({"", "\\end{remarkbox}"}),
      i(0)
    }
  ),
  --snipet for math zone
  s(
    {trig = ";", dscr = "math zone"}, {
      t("$"), i(1, "main body"), t("$"), i(0),
    }
  ),
  --multiline bracket
  s(
    {trig = "mub", dscr = "multiline bracket"}, {
      t("\\left\\{"),
      t("\\begin{aligned}"),
      t({"", "  &"}), i(1, "equation"), t(" \\\\"),
      t({"", "  &"}), i(2, "equation"), t(" \\\\"),
      t({"", "\\end{aligned}"}),
      t("\\right."),
      i(0)
    }
  ),
  --round bracket
  s(
    {trig = "rob", dscr = "round bracket"}, {
      t("\\left("),
      i(1, "content"),
      t("\\right)"),
      i(0)
    }
  ),
  --angled bracket
  s(
    {trig = "anb", dscr = "angled bracket"}, {
      t("\\left\\langle"),
      i(1, "content"),
      t("\\right\\rangle"),
      i(0)
    }
  ),
  --curly bracket
  s(
    {trig = "cub", dscr = "curly bracket"}, {
      t("\\left\\{"),
      i(1, "content"),
      t("\\right\\}"),
      i(0)
    }
  ),
  --square bracket
  s(
    {trig = "sqb", dscr = "square bracket"}, {
      t("\\left["),
      i(1, "content"),
      t("\\right]"),
      i(0)
    }
  ),
  -- norm symbol and absolute value symbol
  s(
    {trig = "nom", dscr = "norm symbol and abs symbol"}, {
      c(1,
        {
          sn(nil, {t("\\left|"), r(1, "user_text"), t("\\right|") }),
          sn(nil, {t("\\left|\\left|"), r(1, "user_text"), t("\\right|\\right|") }),
        }
      ),
    },
    {
      stored = {
        ["user_text"] = i(1, "default_text")
      }
    }
  ),
  -- put subscript text above and under the main text
  s(
    {trig = "abu", dscr = "put text above and under main text"},
    {
      t("\\limits_{"),
      i(1, "text underneath"),
      t("}{"),
      i(2, "text above"),
      t("}")
    }
  ),
}
