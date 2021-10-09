local telescope = require 'telescope'
local actions = require 'telescope.actions'
local themes = require 'telescope.themes'
local util = require 'util'

telescope.setup {
  defaults = vim.tbl_extend('keep', {
    mappings = {
      n = { ['<C-x>'] = false, ['<C-s>'] = actions.select_horizontal },
      i = { ['<C-x>'] = false, ['<C-s>'] = actions.select_horizontal },
    },
  }, themes.get_ivy()),
  pickers = {
    builtin = { previewer = false },
    colorscheme = { enable_preview = true },
    lsp_code_actions = { theme = 'cursor' },
    lsp_range_code_actions = { theme = 'cursor' },
  },
}

telescope.load_extension 'fzy_native'

for k, v in pairs {
  [':'] = 'commands',
  b = 'buffers',
  c = 'current_buffer_fuzzy_find',
  f = 'find_files',
  F = 'file_browser',
  g = 'live_grep',
  h = 'help_tags',
  l = 'loclist',
  q = 'quickfix',
  s = 'spell_suggest',
} do
  util.keymap('n', ('<leader>f' .. k), ('<cmd>Telescope ' .. v .. '<CR>'))
end

util.keymap('n', '<leader>F', '<cmd>Telescope<CR>')
