return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- file style path
    {"L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp"}, -- snippet engine
    "saadparwaiz1/cmp_luasnip", -- luasnip autocompletion
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local keymap = vim.keymap
    -- loads vscod style snippets from installed plugins
    require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/Luasnip"})
    keymap.set({"i", "v"}, "<Tab>", function() luasnip.jump( 1) end, {silent = true, desc = "luasnip jump forward"}
    )
    keymap.set({"i", "v"}, "<S-Tab>", function() luasnip.jump(-1) end, {silent = true,
    desc = "luasnip jump backforward"})
    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<S-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<S-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<S-b>"] = cmp.mapping.scroll_docs(-4), -- next suggestion
        ["<S-f>"] = cmp.mapping.scroll_docs(4),
        ["<S-Space>"] = cmp.mapping.complete(), --show completion suggestion
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<S-e>"] = cmp.mapping.abort(), -- close completion window
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        {name = "nvim_lsp"},
        {name = "luasnip"}, --snippet
        {name = "buffer"}, -- text within current buffer
        {name = "path"}, -- file system paths
      }),
    })
    --keymap.set("i", "<leader>cj", "<cmd>lua require('cmp').select_next_item()<CR>", {desc = "select_next_item"}) -- show lsp definitions
  end
}
