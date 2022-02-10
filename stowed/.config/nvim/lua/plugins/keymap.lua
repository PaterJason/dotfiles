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
  ['<leader>'] = { '<cmd>Telescope builtin<CR>', 'Telescope builtins' },
  l = { name = 'LSP' },
  s = {
    name = 'Telescope Search',
    b = { '<cmd>Telescope current_buffer_fuzzy_find<CR>', 'Current buffer' },
    f = { '<cmd>Telescope find_files<CR>', 'Find Files' },
    g = { '<cmd>Telescope live_grep<CR>', 'Grep' },
    G = { '<cmd>Telescope grep_string<CR>', 'Grep string' },
    h = { '<cmd>Telescope help_tags<CR>', 'Help' },
    l = { '<cmd>Telescope loclist<CR>', 'Loclist' },
    q = { '<cmd>Telescope quickfix<CR>', 'Quickfix' },
    p = { [[<cmd>lua require'telescope'.extensions.project.project{}<CR>]], 'Project' },
  },
  u = { '<cmd>UndotreeToggle<CR>', 'Undotree' },
}, {
  prefix = '<leader>',
})
