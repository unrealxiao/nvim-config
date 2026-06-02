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
    {trig = "beg", dscr = "the begining end box"}, c(
      1, {
      sn(nil, {
        t({"\\begin{"}), i(1), t({"}", ""}),
        t({"  "}), i(2),
        t({"", "\\end{"}), f(rep, {1}, {}), t({"}"}),
        i(0)
      }),
      sn(nil, {
        t({"\\begin{figure}["}), i(1), t({"]", ""}),
        t({"  \\centering", ""}),
        t({"  \\includegraphics[width=0.8\\textwidth]{"}), i(2, "image.png"), t({"}", ""}),
        t({"  \\label{"}), i(3), t({"}", ""}),
        t({"\\end{figure}"}),
        i(0)
      })
      }
    )
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
  --change bracket, including norm and absolute symbol
  s(
    {trig = "brk", dscr = "change the bracket"}, {
      c(1,
        {
          sn(nil, {t("("), r(1, "user_text"), t(")") }),
          sn(nil, {t("["), r(1, "user_text"), t("]") }),
          sn(nil, {t("{"), r(1, "user_text"), t("}") }),
        }
      ),
    },
    {
      stored = {
        ["user_text"] = i(1, "default_text")
      }
    }
  ),
  -- norm symbol and absolute value symbol
  s(
    {trig = "nom", dscr = "norm symbol and abs symbol"}, {
      c(1,
        {
          sn(nil, {t("|"), r(1, "user_text"), t("|") }),
          sn(nil, {t("||"), r(1, "user_text"), t("||") }),
        }
      ),
    },
    {
      stored = {
        ["user_text"] = i(1, "default_text")
      }
    }
  ),
  -- put subscript text under the main text
  s(
    {trig = "und", dscr = "put text under main text"},
    {
      t("\\underset{"),
      i(1, "text underneath"),
      t("}{"),
      i(2, "main text"),
      t("}")
    }
  ),
}
