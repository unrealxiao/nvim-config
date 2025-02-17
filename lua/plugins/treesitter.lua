return{
  "nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
  dependences = {
    "folke/which-key.nvim"
  },
  config = function ()
    local wk = require("which-key")
    require("nvim-treesitter.configs").setup{
      ensure_installed = {"lua", "bash", "latex"},
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<leader>ri",
          node_incremental = "<leader>sn",
          scope_incremental = "<leader>ss",
          node_decremental = "<leader>sd",
        },
      },
      indent = {
        enable = true
      },
    }
    wk.add({
      mode = {"n", "v"},
      {"<leader>s", group = "+treesitter"},
      {"<leader>si", desc = "in normal mode, start incremental selection", mode = "n"},
      {"<leader>sn", desc = "in visual mode, increment to the upper named parent", mode = "v"},
      {"<leader>ss", desc = "in visual mode, increment to the upper scope", mode = "v"},
      {"<leader>sd", desc = "in visual mode, decrement to the previous named node", mode = "v"},
    })
  end
}

