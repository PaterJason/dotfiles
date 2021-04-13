local compe = require'compe'
local util = require'util'

compe.setup{
  source = {
    buffer = true,
    calc = true,
    conjure = {priority = 1001},
    nvim_lsp = true,
    nvim_lua = true,
    path = true,
    snippets_nvim = true,
  },
}

local keymap_opts = {silent = true, expr = true}
util.set_keymaps{
  {'i', '<C-CR>', 'compe#complete()', keymap_opts},
  {'i', '<CR>', [[compe#confirm('<CR>')]], keymap_opts},
  {'i', '<C-e>', [[compe#close('<C-e>')]], keymap_opts},
}
