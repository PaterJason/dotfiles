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
    builtin = { include_extensions = true },
    colorscheme = { enable_preview = true },
    current_buffer_fuzzy_find = { skip_empty_lines = true },
    symbols = { sources = { 'emoji', 'latex' } },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_cursor {
        borderchars = { ' ' },
      },
    },
  },
}

telescope.load_extension 'fzy_native'
telescope.load_extension 'ui-select'
telescope.load_extension 'dap'
