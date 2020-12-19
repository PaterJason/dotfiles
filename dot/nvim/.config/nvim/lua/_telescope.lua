local telescope = require 'telescope'
local actions = require 'telescope.actions'
local previewers = require'telescope.previewers'
local util = require'util'

telescope.load_extension('fzy_native')

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
  ['<leader>T'] = 'builtin',
  ['<leader>tb'] = 'buffers',
  ['<leader>tc'] = 'current_buffer_fuzzy_find',
  ['<leader>tf'] = 'find_files',
  ['<leader>tgb'] = 'git_branches',
  ['<leader>tgc'] = 'git_commits',
  ['<leader>tgC'] = 'git_bcommits',
  ['<leader>tgf'] = 'git_files',
  ['<leader>tgs'] = 'git_status',
  ['<leader>th'] = 'help_tags',
  ['<leader>tl'] = 'loclist',
  ['<leader>tq'] = 'quickfix',
  ['<leader>tr'] = 'live_grep',
  ['<leader>tR'] = 'grep_string',
  ['<leader>tt'] = 'treesitter',
}


for lhs, args in pairs(mappings) do
  util.set_keymap('n', lhs, '<cmd>Telescope ' .. args ..'<CR>')
end
