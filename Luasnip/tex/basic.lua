local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
--repeat function
local function rep(args,_,_)
  return args[1][1]
end
return{
  s("beg", {
    t({"\\begin{"}), i(1), t({"}", ""}),
    t({"  "}), i(2),
    t({"", "\\end{"}), f(rep, {1}, {}), t({"}"}),
    i(0)
  }
  ),
}
