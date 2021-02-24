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
  ['<leader>F'] = 'builtin',
  ['<leader>f:'] = 'commands',
  ['<leader>fb'] = 'buffers',
  ['<leader>fc'] = 'current_buffer_fuzzy_find',
  ['<leader>ff'] = 'find_files',
  ['<leader>fgb'] = 'git_branches',
  ['<leader>fgc'] = 'git_commits',
  ['<leader>fgC'] = 'git_bcommits',
  ['<leader>fgf'] = 'git_files',
  ['<leader>fgs'] = 'git_status',
  ['<leader>fG'] = 'live_grep',
  ['<leader>fh'] = 'help_tags',
  ['<leader>fl'] = 'loclist',
  ['<leader>fq'] = 'quickfix',
  ['<leader>ft'] = 'treesitter',
}

for lhs, args in pairs(mappings) do
  util.set_keymap('n', lhs, '<cmd>Telescope ' .. args ..'<CR>')
end

telescope.load_extension('fzy_native')
