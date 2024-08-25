local set = vim.keymap.set

set({ "i", "s" }, "<Tab>", function()
  if vim.snippet.active({ direction = 1 }) then
    return "<Cmd>lua vim.snippet.jump(1)<CR>"
  else
    return "<Tab>"
  end
end, { expr = true })
set({ "i", "s" }, "<S-Tab>", function()
  if vim.snippet.active({ direction = -1 }) then
    return "<Cmd>lua vim.snippet.jump(-1)<CR>"
  else
    return "<S-Tab>"
  end
end, { expr = true })

vim.keymap.set({ "o" }, "an", function()
  local node = vim.treesitter.get_node({})
  if node == nil then return end
  local start_row, start_col, end_row, end_col = node:range()
  vim.api.nvim_buf_set_mark(0, "<", start_row + 1, start_col, {})
  vim.api.nvim_buf_set_mark(0, ">", end_row + 1, end_col - 1, {})
  vim.cmd("normal! gv")
end, { desc = "Treesitter node", silent = true })
