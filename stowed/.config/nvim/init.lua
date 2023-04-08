require "jp.options"
require "jp.filetype"
require "jp.diagnostic"

if vim.g.neovide then
  require "jp.neovide"
end

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)
require("lazy").setup "plugins"
vim.keymap.set("n", "<leader>p", "<cmd>Lazy<CR>", { desc = "Plugins" })
