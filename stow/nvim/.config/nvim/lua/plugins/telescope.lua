local telescope = require 'telescope'
local actions = require 'telescope.actions'
local themes = require 'telescope.themes'

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
telescope.load_extension 'dap'
