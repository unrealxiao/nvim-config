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
     -- keymapping
     local wk = require("which-key")
     local keymap = vim.keymap
     local builtin = require('telescope.builtin')
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
   end,
}
