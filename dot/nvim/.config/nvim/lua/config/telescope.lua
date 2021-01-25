local telescope = require 'telescope'
local actions = require 'telescope.actions'
local previewers = require'telescope.previewers'
local util = require'config.util'

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ['<C-x>'] = false,
        ['<C-s>'] = actions.goto_file_selection_split,
      },
      i = {
        ['<C-x>'] = false,
        ['<C-s>'] = actions.goto_file_selection_split,
      },
    },
  file_previewer = previewers.vim_buffer_cat.new,
  grep_previewer = previewers.vim_buffer_vimgrep.new,
  qflist_previewer = previewers.vim_buffer_qflist.new,
  }
}

local mappings = {
  ['<leader>F'] = 'builtin',
  ['<leader>fb'] = 'buffers',
  ['<leader>fc'] = 'current_buffer_fuzzy_find',
  ['<leader>ff'] = 'find_files',
  ['<leader>fgb'] = 'git_branches',
  ['<leader>fgc'] = 'git_commits',
  ['<leader>fgC'] = 'git_bcommits',
  ['<leader>fgf'] = 'git_files',
  ['<leader>fgs'] = 'git_status',
  ['<leader>fh'] = 'help_tags',
  ['<leader>fl'] = 'loclist',
  ['<leader>fq'] = 'quickfix',
  ['<leader>fr'] = 'live_grep',
  ['<leader>fR'] = 'grep_string',
  ['<leader>ft'] = 'treesitter',
}


for lhs, args in pairs(mappings) do
  util.set_keymap('n', lhs, '<cmd>Telescope ' .. args ..'<CR>')
end
