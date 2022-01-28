local telescope = require 'telescope'

telescope.setup {
  defaults = {
    color_devicons = false,
    history = false,
    borderchars = { ' ' },
    layout_config = {
      height = 0.4,
    },
    layout_strategy = 'bottom_pane',
    sorting_strategy = 'ascending',
  },
  pickers = {
    builtin = { previewer = false },
    colorscheme = { enable_preview = true },
    current_buffer_fuzzy_find = { skip_empty_lines = true },
    lsp_code_actions = { theme = 'cursor' },
    lsp_range_code_actions = { theme = 'cursor' },
    spell_suggest = { theme = 'cursor' },
    symbols = { sources = { 'emoji', 'latex' } },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_cursor {
        borderchars = { ' ' },
      },
    },
    project = {
      base_dirs = {
        '~/src',
      },
    },
  },
}

telescope.load_extension 'fzy_native'
telescope.load_extension 'ui-select'
telescope.load_extension 'project'
