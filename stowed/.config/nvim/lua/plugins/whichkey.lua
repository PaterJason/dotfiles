local wk = require 'which-key'

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
  d = { name = 'DAP' },
  h = { name = 'Gitsigns' },
  l = { name = 'LSP' },
  s = { name = 'Telescope Search' },
}, {
  prefix = '<leader>',
})