local config = require 'nvim-treesitter.configs'

return config.setup {
  ensure_installed = 'all',
  highlight = {
    enable = true,
    custom_captures = {},
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  indent = { enable = true },
  refactor = {
    smart_rename = {
      enable = true,
      keymaps = { smart_rename = '<leader>rn' },
    },
    navigation = {
      enable = true,
      keymaps = {
        goto_definition = 'gd',
        list_definitions = 'gs',
        goto_next_usage = 'gnu',
        goto_previous_usage = 'gnU',
      },
    },
  },
}
