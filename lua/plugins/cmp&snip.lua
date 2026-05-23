return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- file style path
    {"L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp"}, -- snippet engine
    "saadparwaiz1/cmp_luasnip", -- luasnip autocompletion
    "nvim-telescope/telescope-ui-select.nvim", --set vim.ui.select to telescope
    "nvim-telescope/telescope.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local keymap = vim.keymap
    local notify = require("notify")
    -- Luasnip related config
    require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/Luasnip"})
    local types = require("luasnip.util.types")
    --expand a virtual text whenever a choiceNode is Available
    luasnip.config.setup({
      ext_opts = {
        [types.choiceNode] = {
          active = {
            virt_text = { { "󰥪 choiceNode Available(Ctrl+d del this text)", "LuaSnipNode" } },
          },
        },
        [types.dynamicNode] = {
          active = {
            virt_text = { { "󰌇 dynamicNode Available(Ctrl+d del this text)", "LuaSnipNode" } },
          },
        },
      },
    })
    --expand a notification whenever a choiceNode is available
    local luasnip_group = vim.api.nvim_create_augroup("LuaSnipChoicePopup", { clear = true })

    -- 2. Listen to ChoiceNode events from LuaSnip
    vim.api.nvim_create_autocmd("User", {
        pattern = "LuasnipChoiceNodeEnter",
        group = luasnip_group,
        callback = function()
            -- Use Neovim's built-in notifier. If you use a plugin like nvim-notify or 
            -- noice.nvim, this will automatically look beautiful and float in the corner.
            notify("Choice Node Available! Ctrl+a cycle | Ctrl+h Telescope search]", vim.log.levels.INFO, {
                title = "LuaSnip",
                timeout = 2000, -- Automatically disappears after 2 seconds
            })
        end,
    })
    -- jump index forward by Tab
    keymap.set({ "i", "s" }, "<Tab>", function()
        if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
        end
    end, { silent = true })

    -- Map Shift-Tab to jump backward
    keymap.set({ "i", "s" }, "<S-Tab>", function()
        if luasnip.jumpable(-1) then
            luasnip.jump(-1)
        end
    end, { silent = true })
    require("telescope").setup({
      extensions = {
        ["ui-select"] = {require("telescope.themes").get_dropdown {}}
      }
    })
    require("telescope").load_extension("ui-select")
    keymap.set({"i", "s"}, "<C-h>", function ()
      if luasnip.choice_active() then
        require("luasnip.extras.select_choice")()
      end
    end, {desc = "select luasnip choice with telescope"}) --switch choice with telescope
    keymap.set({"i", "s"}, "<C-a>", function()
      if luasnip.choice_active() then
          luasnip.change_choice(1)
      end
    end, {silent = true, desc = "select luasnip choice"}) --switch choice in choice node
    keymap.set({"i", "s", "n"}, "<C-d>", function()
      if luasnip.expand_or_jumpable() then
        luasnip.unlink_current() -- Instantly kills the snippet session and clears virtual text
      end
    end, { desc = "Cancel Snippet" })
    vim.keymap.set("n", "<leader><leader>s", function()
      require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/Luasnip/" })
      notify("Snippets reloaded!", vim.log.levels.INFO, {
        title = "Luasnip",
        timeout = 2000,
      })
    end, { desc = "Reload LuaSnip snippets" })

    --nvim-cmp related setting

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
