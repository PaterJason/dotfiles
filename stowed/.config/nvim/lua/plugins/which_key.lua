local wk = require 'which-key'
wk.setup {
  plugins = {
    spelling = {
      enabled = true,
    },
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
    },
  },
}

wk.register({
  F = { '<cmd>Telescope builtin<CR>', 'Telescope builtins' },
  ['<space>'] = { '<cmd>Telescope builtin<CR>', 'Telescope builtins' },
  s = {
    name = 'Telescope',
    f = { '<cmd>Telescope find_files<CR>', 'Files' },
    b = { '<cmd>Telescope current_buffer_fuzzy_find<CR>', 'Current buffer' },
    h = { '<cmd>Telescope help_tags<CR>', 'Help' },
    d = { '<cmd>Telescope grep_string<CR>', 'Grep string' },
    p = { '<cmd>Telescope live_grep<CR>', 'Grep' },
    o = { '<cmd>Telescope treesitter<CR>', 'Treesitter' },
  },
  u = { '<cmd>UndotreeToggle<CR>', 'Undotree' },
}, {
  prefix = '<leader>',
})

wk.register({
  a = { '<Plug>(EasyAlign)', 'EasyAlign' },
  c = 'Comment',
}, { prefix = 'g' })

wk.register({
  a = { '<Plug>(EasyAlign)', 'EasyAlign' },
  c = 'Comment',
}, { mode = 'x', prefix = 'g' })
