local telescope = require 'telescope'
local themes = require 'telescope.themes'

themes.get_dropdown()

vim.cmd [[
highlight link TelescopeNormal NormalFloat
highlight link TelescopePreviewNormal NormalFloat
]]

telescope.setup {
  defaults = {
    color_devicons = false,
    history = false,
    border = false,
    preview = { msg_bg_fillchar = '▒' },
    selection_caret = '→ ',
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
    file_browser = { hidden = true, dir_icon = '📁' },
    lsp_code_actions = { theme = 'cursor' },
    lsp_range_code_actions = { theme = 'cursor' },
    spell_suggest = { theme = 'cursor' },
  },
}

telescope.load_extension 'fzy_native'
telescope.load_extension 'dap'
