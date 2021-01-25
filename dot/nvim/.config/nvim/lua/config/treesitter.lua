local config = require'nvim-treesitter.configs'

config.setup {
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ['ib'] = '@block.inner',
        ['ab'] = '@block.outer',
        ['im'] = '@call.inner',
        ['am'] = '@call.outer',
        ['iC'] = '@class.inner',
        ['aC'] = '@class.outer',
        ['ad'] = '@comment.outer',
        ['ic'] = '@conditional.inner',
        ['ac'] = '@conditional.outer',
        ['if'] = '@function.inner',
        ['af'] = '@function.outer',
        ['il'] = '@loop.inner',
        ['al'] = '@loop.outer',
        ['ia'] = '@parameter.inner',
        ['aa'] = '@parameter.outer',
        ['as'] = '@statement.outer',
      },
    },
    swap = {},
    move = {},
    lsp_interop = {},
  },
}
