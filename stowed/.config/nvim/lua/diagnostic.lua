vim.diagnostic.config {
  severity_sort = true,
  signs = false,
}

_G.diagnostic_changed = function()
  if vim.fn.getqflist({ title = 0 }).title == 'Diagnostics' then
    vim.diagnostic.setqflist { open = false }
  end
  if vim.fn.getloclist(0, { title = 0 }).title == 'Diagnostics' then
    vim.diagnostic.setloclist { open = false }
  end
end
vim.cmd 'autocmd DiagnosticChanged * lua diagnostic_changed()'

require('which-key').register {
  ['[d'] = { vim.diagnostic.goto_prev, 'Prev diagnostic' },
  [']d'] = { vim.diagnostic.goto_next, 'Next diagnostic' },
  ['<leader>e'] = { vim.diagnostic.open_float, 'Show diagnostics' },
  ['<leader>q'] = { vim.diagnostic.setloclist, 'Diagnostics loclist' },
  ['<leader>Q'] = { vim.diagnostic.setqflist, 'Diagnostics quickfix' },
}
