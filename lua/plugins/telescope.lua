return{
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
   "nvim-lua/plenary.nvim",
   { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
   "nvim-tree/nvim-web-devicons",
   "folke/which-key.nvim",
  },
  config = function ()
    local telescope = require("telescope")
    telescope.load_extension("fzf")
    -- setup
    local wk = require("which-key")
    local keymap = vim.keymap
    local builtin = require('telescope.builtin')
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local finders = require("telescope.finders")
    local pickers = require("telescope.pickers")
    local conf = require("telescope.config").values

    --a custom function that passes outputs from other
    --pickers to the live_grep 
    telescope.setup({
      defaults = {
        mappings = {
          i = {
            -- [Method 3] Press Ctrl+G inside find_files to grep the selected items
            ["<C-g>"] = function(prompt_bufnr)
              local current_picker = action_state.get_current_picker(prompt_bufnr)
              local multi_selections = current_picker:get_multi_selection()
                local dirs = {}
              if #multi_selections > 0 then
                for _, selection in ipairs(multi_selections) do
                  table.insert(dirs, selection.value)
                end
              else
                local entry = action_state.get_selected_entry()
                if entry then table.insert(dirs, entry.value) end
                end
              actions.close(prompt_bufnr)
              builtin.live_grep({ search_dirs = dirs })
            end,
          },
        },
      },
      })
    --keymapping
    wk.add({
      {mode = "n"},
      {"<leader>f", group = "+telescope"},
    })
    keymap.set('n', '<leader>ff', builtin.find_files, {desc = "fuzzy find file in current working directory"})
    keymap.set('n', '<leader>fg', builtin.live_grep, {desc = "find string"})
    keymap.set('n', '<leader>fr', builtin.oldfiles, {desc = "find recent open file"})
    keymap.set('n', '<leader>fc', builtin.current_buffer_fuzzy_find, {desc = "find string in current buffer"})
    keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics bufnr=0<CR>', {desc = "use lsp diagnostic"})
    keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, {desc = "display lsp symbols"})
    keymap.set('n', '<leader>fm', builtin.command_history, {desc = "display recent command"})
    keymap.set("n", "<leader>fe", "<cmd>Telescope lsp_definitions<CR>", {desc = "show LSP definition"}) -- show lsp definitions
    keymap.set("n", "<leader>fi", "<cmd>Telescope lsp_implementations<CR>", {desc = "show LSP implementations"}) -- show lsp implementations
    keymap.set("n", "<leader>ft", function()
      pickers.new({}, {
        prompt_title = "Enter File Extension (e.g., lua, js) then press Enter",
        finder = finders.new_table({ results = {} }), -- Empty list, purely using the prompt
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            -- Extract whatever you typed into the prompt box
            local text = action_state.get_current_line()
            actions.close(prompt_bufnr)
            if text and text ~= "" then
              builtin.live_grep({ type_filter = text })
            end
          end)
          return true
        end,
      }):find()
    end, { desc = "Telescope Live Grep by File Type" })
    keymap.set("n", "<leader>fh", function()
      builtin.find_files({
        prompt_title = "Select Target Folder for Grep",
        -- Optimized 'fd' command to return directories only
        find_command = { "fd", ".", "--type", "d", "--hidden", "--exclude", ".git" },
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            if selection then
              builtin.live_grep({ search_dirs = {selection.value} })
            end
          end)
          return true
        end,
      })
    end, { desc = "Telescope Live Grep in Selected Folder" })
  end,
}
