return{
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
   "nvim-lua/plenary.nvim",
   { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
   "nvim-tree/nvim-web-devicons",
   "folke/which-key.nvim",
   "rcarriga/nvim-notify",
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
    local notify = require("notify")
    local action_utils = require("telescope.actions.utils")
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
    --set up find files then grep_live within all the matching files
    local function grep_filtered_files(prompt_bufnr)
      local files = {}

      -- Gather all matching entries currently visible in the filtered results list
      action_utils.map_entries(prompt_bufnr, function(entry)
          table.insert(files, entry[1] or entry.value)
      end)

      -- Close the current find_files Telescope window
      actions.close(prompt_bufnr)

      if vim.tbl_isempty(files) then
          notify("No matching files found to grep within.", vim.log.levels.WARN,
            {title = "telescope", timeout = 1000})
          return
      end

      -- Launch live_grep strictly within those files
      builtin.live_grep({
          search_dirs = files,
          prompt_title = "Live Grep (Within Filtered Files)",
      })
  end

  -- 2. Create a wrapper function that attaches the keymap on-the-fly
  local function find_files_then_grep()
      notify("press Ctrl+g to pass files to live_grep", vim.log.levels.INFO, {
        title = "telescope", timeout = 2000})
      builtin.find_files({
          attach_mappings = function(prompt_bufnr, map)
              -- We bind <C-g> in both Insert (i) and Normal (n) modes inside this session
              map({ "i", "n" }, "<C-g>", grep_filtered_files)
              -- Keep standard Telescope keymaps working as normal
              return true
          end,
      })
  end

  -- 3. Standard Neovim keymap definition
  vim.keymap.set('n', '<leader>fb', find_files_then_grep, { desc = "Find files, then pass matched files to live_grep" })

    end,
}
