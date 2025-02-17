return{
  "lervag/vimtex",
  config = function ()
    vim.cmd([[
    filetype plugin indent on
    syntax enable
    let g:vimtex_view_method = 'zathura'
    ]])
  end,
}
