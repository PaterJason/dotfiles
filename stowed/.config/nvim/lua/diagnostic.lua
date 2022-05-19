vim.diagnostic.config {
  severity_sort = true,
  signs = false,
  float = {border = "single"}
}

local augroup = vim.api.nvim_create_augroup('DiagnosticLists', {})
vim.api.nvim_create_autocmd('DiagnosticChanged', {
  callback = function()
    if vim.fn.getqflist({ title = 0 }).title == 'Diagnostics' then
      vim.diagnostic.setqflist { open = false }
    end
    if vim.fn.getloclist(0, { title = 0 }).title == 'Diagnostics' then
      vim.diagnostic.setloclist { open = false }
    end
  end,
  group = augroup,
})

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostics' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics loclist' })
vim.keymap.set('n', '<leader>Q', vim.diagnostic.setqflist, { desc = 'Diagnostics quickfix' })
