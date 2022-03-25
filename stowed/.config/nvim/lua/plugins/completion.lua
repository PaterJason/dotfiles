local cmp = require 'cmp'
local luasnip = require 'luasnip'

require('luasnip.loaders.from_vscode').load()
vim.api.nvim_set_keymap('i', '<C-l>', '<Plug>luasnip-expand-or-jump', {})
vim.api.nvim_set_keymap('s', '<C-l>', '<Plug>luasnip-expand-or-jump', {})
vim.api.nvim_set_keymap('i', '<C-h>', '<Plug>luasnip-jump-prev', {})
vim.api.nvim_set_keymap('s', '<C-h>', '<Plug>luasnip-jump-prev', {})

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(8), { 'i', 'c' }),
    ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-8), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ['<C-y>'] = cmp.mapping.confirm { select = true },
  },
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'conjure' },
  }, {
    { name = 'buffer' },
  }),
})

cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' },
  },
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})
