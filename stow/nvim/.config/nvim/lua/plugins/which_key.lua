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
  f = {
    name = 'Telescope',
    [':'] = { '<cmd>Telescope commands<CR>', 'Commands' },
    b = { '<cmd>Telescope buffers<CR>', 'Buffers' },
    c = { '<cmd>Telescope current_buffer_fuzzy_find<CR>', 'Current buffer' },
    f = { '<cmd>Telescope find_files<CR>', 'Files' },
    F = { '<cmd>Telescope file_browser<CR>', 'File browser' },
    g = { '<cmd>Telescope live_grep<CR>', 'Grep' },
    G = { '<cmd>Telescope grep_string<CR>', 'Grep string' },
    h = { '<cmd>Telescope help_tags<CR>', 'Help' },
    l = { '<cmd>Telescope loclist<CR>', 'Loclist' },
    q = { '<cmd>Telescope quickfix<CR>', 'Quickfix' },
    s = { '<cmd>Telescope spell_suggest<CR>', 'Spell' },
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
