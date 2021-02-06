local compe = require'compe'
local util = require'config.util'

compe.setup{
  source = {
    buffer = true,
    calc = true;
    conjure = {priority = 1001},
    nvim_lsp = true,
    nvim_lua = true;
    path = true,
    treesitter = true
  },
}

local keymap_opts = {silent = true, expr = true}
util.set_maps{
  {'i', '<C-CR>', 'compe#complete()', keymap_opts},
  {'i', '<CR>', [[compe#confirm('<CR>')]], keymap_opts},
  {'i', '<C-e>', [[compe#close('<C-e>')]], keymap_opts},

  {'i', '<C-l>', [[vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>']], keymap_opts},
  {'s', '<C-l>', [[vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>']], keymap_opts},
  {'i', '<C-h>', [[vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>']], keymap_opts},
  {'s', '<C-h>', [[vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>']], keymap_opts},
}
