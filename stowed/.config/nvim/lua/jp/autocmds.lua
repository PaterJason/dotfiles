local augroup = vim.api.nvim_create_augroup("JPConfig", {})
local create = vim.api.nvim_create_autocmd

create("TextYankPost", {
  callback = function(_args) vim.hl.on_yank({ timeout = 250 }) end,
  group = augroup,
  desc = "Highlight on yank",
})
