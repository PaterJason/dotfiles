require "options"
require "filetype"
require "diagnostic"

if vim.g.neovide then
  require "neovide"
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
require("lazy").setup("plugins", {
  ui = {
    icons = {
      cmd = "⌘",
      config = "",
      event = "",
      ft = "",
      init = "",
      keys = "",
      plugin = "",
      runtime = "",
      source = "",
      start = "",
      task = "",
      lazy = " ",
    },
  },
})
vim.keymap.set("n", "<leader>p", "<cmd>Lazy<CR>", { desc = "Plugins" })
