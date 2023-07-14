local M = {
  "folke/which-key.nvim",
}

function M.config()
  local wk = require "which-key"
  wk.setup {
    plugins = {
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
      },
    },
  }
  wk.register({
    d = { name = "DAP" },
    h = { name = "Git hunks" },
    l = { name = "LSP" },
    s = { name = "Telescope Search" },
  }, {
    prefix = "<leader>",
  })
end

return M
