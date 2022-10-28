local wk = require "which-key"

wk.setup {
  plugins = {
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
    },
  },
  window = {
    border = "single",
  },
}

wk.register({
  d = { name = "DAP" },
  h = { name = "Git hunks" },
  l = { name = "LSP" },
  s = { name = "Telescope Search" },
  t = { name = "Toggle" },
}, {
  prefix = "<leader>",
})
