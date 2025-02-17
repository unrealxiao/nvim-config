local opt = vim.opt -- for conciseness

--line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
vim.cmd([[
  function MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
      " select the highlighting
      if i + 1 == tabpagenr()
        let s ..= '%#TabLineSel#'
      else
        let s ..= '%#TabLine#'
      endif

      " set the tab page number (for mouse clicks)
      let s ..= '%' .. (i + 1) .. 'T'

      " the label is made by MyTabLabel()
      let s ..= ' %{MyTabLabel(' .. (i + 1) .. ')} '
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    let s ..= '%#TabLineFill#%T'

    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
      let s ..= '%=%#TabLine#%999Xclose'
    endif

    return s
  endfunction

  function MyTabLabel(n)
	  let buflist = tabpagebuflist(a:n)
	  let winnr = tabpagewinnr(a:n)
	  return fnamemodify(bufname(buflist[winnr - 1]), ':t')
	endfunction
	set tabline=%!MyTabLine()
]])
--line wrappin
opt.wrap = false --prevent text from wrapping

--cursor line
opt.cursorline = true

--backspace
opt.backspace = "indent,eol,start"
--appearance
opt.termguicolors = true
opt.signcolumn = "yes"
vim.api.nvim_set_hl(0, "EndOfBuffer", {fg = "#776561"}) -- change color of tilde

-- clipboard
opt.clipboard:append("unnamedplus") --force nvim to use system clipboard

-- split windows
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")


