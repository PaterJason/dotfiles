local telescope = require 'telescope'

telescope.setup {
  pickers = {
    builtin = { previewer = false },
    colorscheme = { enable_preview = true },
    lsp_code_actions = { theme = 'cursor' },
    lsp_range_code_actions = { theme = 'cursor' },
  },
}

telescope.load_extension 'fzy_native'
telescope.load_extension 'dap'
