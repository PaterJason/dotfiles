local cmp = require'cmp'
local luasnip = require 'luasnip'
local util = require'util'

cmp.setup{
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(8),
    ['<C-u>'] = cmp.mapping.scroll_docs(-8),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(util.replace_termcodes('<C-n>'), 'n')
      elseif luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(util.replace_termcodes('<Plug>luasnip-expand-or-jump'), '')
      else
        fallback()
      end
    end,
      {'i', 's',}),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(util.replace_termcodes('<C-p>'), 'n')
      elseif luasnip.jumpable(-1) then
        vim.fn.feedkeys(util.replace_termcodes('<Plug>luasnip-jump-prev'), '')
      else
        fallback()
      end
    end,
      {'i', 's',}),
  },
  sources = {
    {name = 'conjure'},
    {name = 'luasnip'},
    {name = 'nvim_lsp'},
    {name = 'path'},
  },
}
