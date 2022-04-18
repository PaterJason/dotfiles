require('which-key').register {
  ['<leader>f'] = { '<cmd>Format<CR>', 'Format' },
}
vim.keymap.set('n', '<leader>f', '<cmd>Format<CR>', { desc = 'Format' })

require('formatter').setup {
  filetype = {
    lua = {
      function()
        return {
          exe = 'stylua',
          args = {
            '--config-path ~/.config/stylua/stylua.toml',
            '-',
          },
          stdin = true,
        }
      end,
    },
    fish = {
      function()
        return {
          exe = 'fish_indent',
          stdin = true,
        }
      end,
    },
  },
}
