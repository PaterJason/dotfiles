vim.diagnostic.config {
  severity_sort = true,
  signs = false,
}

vim.keymap.set("n", "[d", function()
  vim.diagnostic.goto_prev { float = false }
end, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", function()
  vim.diagnostic.goto_next { float = false }
end, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostics" })
