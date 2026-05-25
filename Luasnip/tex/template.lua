
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local sn = ls.snippet_node
local d = ls.dynamic_node

return{
  --lecture note template
  s(
    {trig = "lecture", dscr = "lecture template"}, {
      t(
        "\\documentclass[a4paper, 12pt]{report}"
      ),
      t({
        "", "\\usepackage{setspace}"
      }),
      t({
        "", "\\onehalfspacing"
      }),
      t({
        "", "\\usepackage[english]{babel}"
      }),
      t({
        "", "\\usepackage{sleek}"
      }),
      t({
        "", "\\usepackage{sleek-title}"
      }),
      t({
        "", "\\usepackage{sleek-theorems}"
      }),
      t({
        "", "\\institute{Indiana University}"
      }),
      t({
        "", "\\title{"
      }), i(1, "On the number of primes below a given magnitude"), t("}"),
      t({
        "", "\\author{\\textit{Author}\\\\Xiao \\textsc{Liu}}"
      }),
      t({
        "", "\\date{\\today}"
      }),
      t({
        "", "\\begin{document}"
      }),
      t({
        "", "  \\maketitle"
      }),
      t({
        "", "  \\clearpage"
      }),
      t({
        "", "  \\pagenumbering{roman}"
      }),
      t({
        "", "  \\tableofcontents"
      }),
      t({
        "", "  \\clearpage"
      }),
      t({
        "", "  \\pagenumbering{arabic}"
      }),
      t({
        "", "  \\chapter{"
      }), i(2, "Introduction"), t({"}", ""}),
      t({
        "", "  \\section{"
      }), i(3, "Sleek"), t({"}",}),
      t({
        "", "\\end{document}"
      })
    }
  ),
}
