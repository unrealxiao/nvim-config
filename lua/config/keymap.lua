vim.g.mapleader = " "
vim.g.maplocalleader = ","

local keymap = vim.keymap

-- general setup
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
keymap.set("n", "<leader>sl", "<C-w>h", { desc = "Move cursor to left window" })
keymap.set("n", "<leader>sr", "<C-w>l", { desc = "Move cursor to right window" })
keymap.set("n", "<leader>sj", "<C-w>j", { desc = "Move cursor to down window" })
keymap.set("n", "<leader>sk", "<C-w>k", { desc = "Move cursor to up window" })

-- Move by visual lines, not actual lines
keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })




keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab

keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
-- access to system clipboard
keymap.set({"n", "v"}, "<leader>y", [["+y]])

--below are functions specific for latex 
local function create_inkscape_figure() -- open Inkscape directly in LaTeX
    -- Get the directory of the current LaTeX file
    local root_dir = vim.fn.expand('%:p:h')
    -- Prompt for a figure name
    local name = vim.fn.input('Figure name: ')
    if name == '' then
        print("Operation cancelled.")
        return
    end

    -- Sanitize name and build paths
    local filename = name:gsub('%s+', '-'):lower() .. '.svg'
    local filepath = root_dir .. '/figure/' .. filename
    local svg_content = [[<?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <svg xmlns="http://www.w3.org/2000/svg" width="200" height="200">
      </svg>
    ]]
    local dir = root_dir .. '/figure'
    if vim.fn.isdirectory(dir) ==0 then
      vim.fn.mkdir(dir, "p")
    end
    local file = io.open(filepath, "w")
    if file then
        file:write(svg_content)
        file:close()
    else
        vim.notify("Could not create SVG file at " .. filepath, vim.log.levels.ERROR)
        return
    end

    -- The \includesvg command needs to be relative to the root/main.tex
    -- depending on your document structure.
    --local boilerplate = {
      --"\\begin{figure}[htbp]",
      --" \\centering",
      --string.format("  \\includegraphics[width=0.8\\textwidth]{%s.pdf}", name),
      --"  \\caption{Description}",
      --string.format("  \\label{fig:%s}", name),
      --"\\end{figure}"
    --}
    -- 3. Insert boilerplate into the current buffer
    --local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    --vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, boilerplate)
    -- Launch Inkscape as a background process
    -- 'detach = true' keeps Inkscape open even if you close Neovim
    vim.fn.jobstart(
      {'inkscape', filepath},
      {
        detach = true,
        on_exit = function (_, code)
          if code ~= 0 then
            vim.notify("Inkscape existed with code " .. code, vim.log.levels.ERROR)
          end
        end
      }
    )
end
keymap.set({"n"}, '<leader>g', create_inkscape_figure, { desc = 'Create Inkscape Figure' })
