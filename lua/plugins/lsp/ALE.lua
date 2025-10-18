return{
  'dense-analysis/ale',
  config = function ()
    local g = vim.g
    g.ale_disable_lsp = 'auto'
    g.ale_use_neovim_diagnostics_api = 1
    g.ale_linters = {
      python = {'pylint'},
      sh = {'shellcheck'},
      lua = {'lua_ls'},
    }
  end
}
