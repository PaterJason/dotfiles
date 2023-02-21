vim.diagnostic.config {
  severity_sort = true,
  signs = false,
}

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics" })
