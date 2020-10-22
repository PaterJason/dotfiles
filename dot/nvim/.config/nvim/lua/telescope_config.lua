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

local mappings = {
  ['<leader>t:'] = 'commands',
  ['<leader>t?'] = 'builtin',
  ['<leader>tb'] = 'buffers',
  ['<leader>tc'] = 'current_buffer_fuzzy_find',
  ['<leader>tf'] = 'find_files',
  ['<leader>tF'] = 'git_files',
  ['<leader>tG'] = 'grep_string',
  ['<leader>tg'] = 'live_grep',
  ['<leader>tH'] = 'help_tags',
  ['<leader>th:'] = 'command_history',
  ['<leader>thf'] = 'oldfiles',
  ['<leader>tl'] = 'loclist',
  ['<leader>tm'] = 'man_pages',
  ['<leader>tq'] = 'quickfix',
  ['<leader>tR'] = 'reloader',
}

for lhs, builtin in pairs(mappings) do
  util.set_keymap('n', lhs, "<cmd>lua require'telescope.builtin'." .. builtin .. "{}<CR>")
end
