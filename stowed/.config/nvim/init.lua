require "jp.options"
require "jp.lsp"

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if vim.loop.fs_stat(lazypath) then
  vim
    .system({
      "git",
      "clone",
      "--filter=blob:none",
      "--single-branch",
      "https://github.com/folke/lazy.nvim.git",
      lazypath,
    })
    :wait()
end
vim.opt.runtimepath:prepend(lazypath)
require("lazy").setup("plugins", {
  dev = {
    path = vim.fs.normalize "~/src/nvim",
    patterns = { "PaterJason" },
    fallback = true,
  },
  change_detection = {
    notify = false,
  },
})
vim.keymap.set("n", "<leader>p", "<Cmd>Lazy<CR>", { desc = "Plugins" })
