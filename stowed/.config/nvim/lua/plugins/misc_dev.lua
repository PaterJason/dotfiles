MiniDeps.later(function()
  MiniDeps.add({ source = "mfussenegger/nvim-lint" })

  local lint = require("lint")

  lint.linters_by_ft = {
    fish = { "fish" },
  }

  local augroup = vim.api.nvim_create_augroup("nvim_lint", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = augroup,
    callback = function() lint.try_lint() end,
  })
end)

MiniDeps.later(function()
  MiniDeps.add({ source = "stevearc/conform.nvim" })

  require("conform").setup({
    formatters_by_ft = {
      clojure = { "zprint" },
      fish = { "fish_indent" },
      lua = { "stylua" },

      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      vue = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      less = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      ["markdown.mdx"] = { "prettier" },
      graphql = { "prettier" },
      handlebars = { "prettier" },
    },
  })
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
    require("conform").format({ async = true, lsp_fallback = true, range = range })
  end, { range = true, desc = "Format with conform.nvim" })
  vim.keymap.set(
    { "n", "v" },
    "<Leader>f",
    ":Format<CR>",
    { silent = true, desc = "Format with conform.nvim" }
  )
end)
