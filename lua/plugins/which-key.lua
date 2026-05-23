return{
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependences = {
    "echasnovski/mini.icons"
  },
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 200
  end,
  config = function()
    local wk = require("which-key")
    wk.add({
      {mode = "n"},
      {"<leader>b", group = "buffer"},
      {"<leader>t", group = "tab"},
      {"<leader>s", group = "window"},
      {"<localleader>l", group = "vimtex"}
   })
  end
}
