local compe = require'compe'
local util = require'config.util'

compe.setup{
  enabled = true,
  source = {
    path = true,
    buffer = true,
    nvim_lsp = true,
    conjure = {
      priority = 1001,
    },
  },
}

local keymap_opts = {noremap = true, silent = true, expr = true}
util.set_maps{
  {'i', '<C-Tab>', 'compe#complete()', keymap_opts},
  {'i', '<CR>', [[compe#confirm('<CR>')]], keymap_opts},
  {'i', '<C-e>', [[compe#close('<C-e>')]], keymap_opts},
}
