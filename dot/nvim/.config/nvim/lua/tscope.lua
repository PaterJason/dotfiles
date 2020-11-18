local telescope = require 'telescope'
local actions = require 'telescope.actions'
local util = require'util'

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ["<C-x>"] = false,
        ["<C-s>"] = actions.goto_file_selection_split,
      },
      i = {
        ["<C-x>"] = false,
        ["<C-s>"] = actions.goto_file_selection_split,
      },
    },
  }
}

util.set_keymap('n', '<leader>t', "<cmd>lua require'telescope.builtin'.builtin{}<CR>")
