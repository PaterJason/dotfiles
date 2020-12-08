local config = require'nvim-treesitter.configs'

config.setup {
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
  },
  indent = {
    enable = false,
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ['ib'] = '@block.inner',
        ['ab'] = '@block.outer',
        ['iF'] = '@call.inner',
        ['aF'] = '@call.outer',
        ['io'] = '@class.inner',
        ['ao'] = '@class.outer',
        ['a/'] = '@comment.outer',
        ['ic'] = '@conditional.inner',
        ['ac'] = '@conditional.outer',
        ['if'] = '@function.inner',
        ['af'] = '@function.outer',
        ['il'] = '@loop.inner',
        ['al'] = '@loop.outer',
        ['ia'] = '@parameter.inner',
        ['as'] = '@statement.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>sa"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>Sa"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      goto_next_start = {
        ['<leader>nb'] = '@block.outer',
        ['<leader>nF'] = '@call.outer',
        ['<leader>no'] = '@class.outer',
        ['<leader>n/'] = '@comment.outer',
        ['<leader>nc'] = '@conditional.outer',
        ['<leader>nf'] = '@function.outer',
        ['<leader>nl'] = '@loop.outer',
        ['<leader>na'] = '@parameter.inner',
        ['<leader>ns'] = '@statement.outer',
      },
      goto_next_end = {
        ['<leader>Nb'] = '@block.outer',
        ['<leader>NF'] = '@call.outer',
        ['<leader>No'] = '@class.outer',
        ['<leader>N/'] = '@comment.outer',
        ['<leader>Nc'] = '@conditional.outer',
        ['<leader>Nf'] = '@function.outer',
        ['<leader>Nl'] = '@loop.outer',
        ['<leader>Na'] = '@parameter.inner',
        ['<leader>Ns'] = '@statement.outer',
      },
      goto_previous_start = {
        ['<leader>pb'] = '@block.outer',
        ['<leader>pF'] = '@call.outer',
        ['<leader>po'] = '@class.outer',
        ['<leader>p/'] = '@comment.outer',
        ['<leader>pc'] = '@conditional.outer',
        ['<leader>pf'] = '@function.outer',
        ['<leader>pl'] = '@loop.outer',
        ['<leader>pa'] = '@parameter.inner',
        ['<leader>ps'] = '@statement.outer',
      },
      goto_previous_end = {
        ['<leader>Pb'] = '@block.outer',
        ['<leader>PF'] = '@call.outer',
        ['<leader>Po'] = '@class.outer',
        ['<leader>P/'] = '@comment.outer',
        ['<leader>Pc'] = '@conditional.outer',
        ['<leader>Pf'] = '@function.outer',
        ['<leader>Pl'] = '@loop.outer',
        ['<leader>Pa'] = '@parameter.inner',
        ['<leader>Ps'] = '@statement.outer',
      },
    },
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
  },
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = true },
  },
}
