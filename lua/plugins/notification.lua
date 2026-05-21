return{
  "rcarriga/nvim-notify",
  config = function ()
    local notify = require("notify")
    notify.setup({
      stages = "fade",
      timeout = 2000,
      on_open = function (win)
        vim.api.nvim_win_set_config(win, {
          zindex = 175,
          focusable = false
        })
      end,
    })
    vim.notify = notify
  end,
}
