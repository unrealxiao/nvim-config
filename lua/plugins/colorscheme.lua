return {
"EdenEast/nightfox.nvim",
priority = 1000,
config = function()
  --load the color scheme nordfox
  local palette = {
    all = {
    -- A palette also defines the following:
    --   bg0, bg1, bg2, bg3, bg4, fg0, fg1, fg2, fg3, sel0, sel1, comment
    --
    -- These are the different foreground and background shades used by the theme.
    -- The base bg and fg is 1, 0 is normally the dark alternative. The others are
    -- incrementally lighter versions.
    bg0 = "#29303e",
    bg1 = "#2e3440",
    -- sel is different types of selection colors.
    sel0 = "#3e4a5b", -- Popup bg, visual selection bg
    sel1 = "#4f6074", -- Popup sel bg, search bg

    -- comment is the definition of the comment color.
    comment = "#60728a",
    },
  }

  local spec = {
    all = {
      inactive = "#090909",
    },
  }

  local groups = {
    all = {
      PmenuSel = { bg = "#73daca", fg = "bg0" },
    },
  }
  require("nightfox").setup({ palettes = palette, specs = spec, groups = groups, modules = nvimtree})
  vim.cmd [[
  colorscheme nightfox
  ]]
  --additional color groups
  vim.api.nvim_set_hl(0, "LuaSnipNode", {
    fg = "#80F527",       -- Bright Green foreground text color
    bg = "NONE",          -- Keep background transparent to avoid text boxes overlapping notes
    italic = true,        -- Make it distinct from standard mathematical text strings
    bold= true,
})
  

 end,
}
