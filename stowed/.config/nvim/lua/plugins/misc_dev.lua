---@type LazySpec
local M = {
  {
    "mfussenegger/nvim-lint",
    config = function()
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
    end,
  },
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup {
        formatters_by_ft = {
          fish = { "fish_indent" },
          lua = { "stylua" },
        },
      }
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        require("conform").format { async = true, lsp_fallback = true, range = range }
      end, { range = true, desc = "Format with conform.nvim" })
      vim.keymap.set({ "n", "v" }, "<Leader>f", ":Format<CR>", { desc = "Format with conform.nvim" })
    end,
  },
}

return M
