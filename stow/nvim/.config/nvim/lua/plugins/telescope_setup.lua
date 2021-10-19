local util = require 'util'

for keymap, builtin in pairs {
  [':'] = 'commands',
  b = 'buffers',
  c = 'current_buffer_fuzzy_find',
  ['d:'] = 'dap commands',
  dc = 'dap configurations',
  dl = 'dap list_breakpoints',
  dv = 'dap variables',
  df = 'dap frames',
  f = 'find_files',
  F = 'file_browser',
  g = 'live_grep',
  G = 'grep_string',
  h = 'help_tags',
  l = 'loclist',
  q = 'quickfix',
  s = 'spell_suggest',
} do
  util.keymap('n', ('<leader>f' .. keymap), ('<cmd>Telescope ' .. builtin .. '<CR>'))
end

util.keymap('n', '<leader>F', '<cmd>Telescope<CR>')
