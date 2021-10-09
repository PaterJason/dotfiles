local cmp = require 'cmp'
local luasnip = require 'luasnip'
local util = require 'util'

return cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if 1 == vim.fn.pumvisible() then
        return vim.fn.feedkeys(util.replace_termcodes '<C-n>', 'n')
      elseif luasnip.expand_or_jumpable() then
        return vim.fn.feedkeys(util.replace_termcodes '<Plug>luasnip-expand-or-jump', '')
      else
        return fallback()
      end
    end, {
      'i',
      's',
    }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if 1 == vim.fn.pumvisible() then
        return vim.fn.feedkeys(util.replace_termcodes '<C-p>', 'n')
      elseif luasnip.expand_or_jumpable() then
        return vim.fn.feedkeys(util.replace_termcodes '<Plug>luasnip-jump-prev', '')
      else
        return fallback()
      end
    end, {
      'i',
      's',
    }),
  },
  sources = {
    { name = 'conjure' },
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'path' },
  },
}
