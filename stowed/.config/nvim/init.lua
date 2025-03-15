require("jp.options")
require("jp.autocmds")
require("jp.keymaps")
require("jp.lsp")

local path_package = vim.fn.stdpath("data") .. "/site"
local mini_path = path_package .. "/pack/deps/start/mini.nvim"
if not vim.uv.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  vim
    .system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/echasnovski/mini.nvim",
      mini_path,
    })
    :wait()
  vim.cmd("packadd mini.nvim | helptags ALL")
end

require("mini.deps").setup({ path = { package = path_package } })
MiniDeps.later(function()
  vim.keymap.set("n", "<Leader>pc", "<Cmd>DepsClean<CR>", { desc = "Clean" })
  vim.keymap.set("n", "<Leader>pl", "<Cmd>DepsShowLog<CR>", { desc = "Show Log" })
  vim.keymap.set("n", "<Leader>pu", "<Cmd>DepsUpdate<CR>", { desc = "Update" })
end)

require("plugins.tpope")
require("plugins.mini")
require("plugins.misc")

require("plugins.dap")
require("plugins.lsp")
require("plugins.misc_dev")
require("plugins.treesitter")

MiniDeps.later(function()
  -- Loaded modules after all plugins are loaded
  DEPSPOST_MODNAMES = vim.tbl_keys(package.loaded)
end)
