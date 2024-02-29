require("jp.options")
require("jp.autocmds")
require("jp.lsp")

local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/echasnovski/mini.nvim",
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd("packadd mini.nvim | helptags ALL")
end

require("mini.deps").setup({ path = { package = path_package } })
MiniDeps.later(function()
  vim.keymap.set("n", "<leader>pc", vim.cmd.DepsClean, { desc = "Clean" })
  vim.keymap.set("n", "<leader>pl", vim.cmd.DepsShowLog, { desc = "Show Log" })
  vim.keymap.set("n", "<leader>pu", vim.cmd.DepsUpdate, { desc = "Update" })
end)

require("plugins.mini")
require("plugins.misc")

require("plugins.cmp")
require("plugins.dap")
require("plugins.git")
require("plugins.lsp")
require("plugins.misc_dev")
require("plugins.tpope")
require("plugins.treesitter")
