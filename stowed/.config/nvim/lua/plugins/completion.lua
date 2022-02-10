local cmp = require 'cmp'
local luasnip = require 'luasnip'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
end

require('luasnip.loaders.from_vscode').load()

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  experimental = {
    ghost_text = {
      hl_group = 'LspCodeLens',
    },
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(8),
    ['<C-u>'] = cmp.mapping.scroll_docs(-8),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm { select = true },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
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
}

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

local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())