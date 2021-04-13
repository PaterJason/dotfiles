local telescope = require'telescope'
local actions = require'telescope.actions'
local util = require'util'

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ['<C-x>'] = false,
        ['<C-s>'] = actions.select_horizontal,
      },
      i = {
        ['<C-x>'] = false,
        ['<C-s>'] = actions.select_horizontal,
      },
    },
  }
}

local mappings = {
  [':'] = 'commands',
  b = 'buffers',
  c = 'current_buffer_fuzzy_find',
  f = 'find_files',
  F = 'file_browser',
  gb = 'git_branches',
  gc = 'git_commits',
  gC = 'git_bcommits',
  gf = 'git_files',
  gs = 'git_status',
  G = 'live_grep',
  h = 'help_tags',
  l = 'loclist',
  q = 'quickfix',
  t = 'treesitter',
}

for keys, args in pairs(mappings) do
  util.set_keymap('n', '<leader>f' .. keys, '<cmd>Telescope ' .. args ..'<CR>')
end
util.set_keymap('n', '<leader>F', '<cmd>Telescope<CR>')
