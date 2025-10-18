vim.g.mapleader = " "
vim.g.maplocalleader = ","

local keymap = vim.keymap

-- general setup
keymap.set("n", "<leader>bv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>bh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>be", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>bx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move cursor to left window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move cursor to right window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move cursor to down window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move cursor to up window" })






keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab

keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
-- access to system clipboard
keymap.set({"n", "v"}, "<leader>y", [["+y]])
