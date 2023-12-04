---@type LazySpec
local M = {
  "mfussenegger/nvim-lint",
}

function M.config()
  local lint = require "lint"

  lint.linters_by_ft = {
    fish = { "fish" },
  }

  local augroup = vim.api.nvim_create_augroup("nvim_lint", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = augroup,
    callback = function()
      lint.try_lint()
    end,
  })
end

return M
