vim.keymap.set({ "o" }, "an", function()
  local node = vim.treesitter.get_node({})
  if node == nil then return end
  local start_row, start_col, end_row, end_col = node:range()
  if not (start_row and start_col and end_row and end_col) then return end
  vim.api.nvim_buf_set_mark(0, "<", start_row + 1, start_col, {})
  vim.api.nvim_buf_set_mark(0, ">", end_row + 1, end_col - 1, {})
  vim.cmd("normal! gv")
end, { desc = "Treesitter node", silent = true })
