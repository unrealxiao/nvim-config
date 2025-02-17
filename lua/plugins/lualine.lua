return{
  "nvim-lualine/lualine.nvim",
  dependencies = {
    {'nvim-tree/nvim-web-devicons', opt = true}
  },
  config = function ()
    require("lualine").setup {
      options = {
        theme = "auto",
        section_separators = "",
        component_separators = "|"
      },
    }
    vim.cmd([[set noshowmode]])
  end,
}
