local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local sn = ls.snippet_node
local d = ls.dynamic_node
--repeat function
local function rep(args,_,_)
  return args[1][1]
end

return{
  --snipet for figure and
  -- begin{} end{} pattern
  s(
    "beg", c(
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
}
