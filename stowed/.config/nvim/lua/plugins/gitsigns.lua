require('gitsigns').setup {
  preview_config = {},
  signcolumn = false,
  numhl = true,
  on_attach = function(bufnr)
    vim.keymap.set('n', '[c', '<cmd>Gitsigns prev_hunk<CR>', { buffer = bufnr, desc = 'Prev hunk' })
    vim.keymap.set('n', ']c', '<cmd>Gitsigns next_hunk<CR>', { buffer = bufnr, desc = 'Next hunk' })

    vim.keymap.set('n', '<leader>hb', '<cmd>Gitsigns blame_line<CR>', { buffer = bufnr, desc = 'Blame line' })
    vim.keymap.set('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>', { buffer = bufnr, desc = 'Diffthis' })
    vim.keymap.set('n', '<leader>hl', '<cmd>Gitsigns setloclist<CR>', { buffer = bufnr, desc = 'Set loclist' })
    vim.keymap.set('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>', { buffer = bufnr, desc = 'Preview hunk' })
    vim.keymap.set('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>', { buffer = bufnr, desc = 'Reset hunk' })
    vim.keymap.set('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>', { buffer = bufnr, desc = 'Stage hunk' })
    vim.keymap.set('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>', { buffer = bufnr, desc = 'Undo stage hunk' })
  end,
}
