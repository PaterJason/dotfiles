local augroup = vim.api.nvim_create_augroup("JPConfig", { clear = true })
local create = vim.api.nvim_create_autocmd

create({ "TextYankPost" }, {
  callback = function() vim.highlight.on_yank({ timeout = 250 }) end,
  group = augroup,
  desc = "Highlight on yank",
})
