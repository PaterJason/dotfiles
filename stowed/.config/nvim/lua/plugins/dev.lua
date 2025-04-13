MiniDeps.now(function()
  MiniDeps.add({
    source = "neovim/nvim-lspconfig",
    depends = {
      "b0o/SchemaStore.nvim",
    },
  })
end)

MiniDeps.later(function()
  MiniDeps.add("mfussenegger/nvim-lint")

  local lint = require("lint")

  lint.linters_by_ft = {
    fish = { "fish" },
    go = { "golangcilint" },
  }

  local augroup = vim.api.nvim_create_augroup("nvim_lint", {})
  vim.api.nvim_create_autocmd(
    { "BufWritePost", "BufReadPost" },
    { group = augroup, callback = function(_args) lint.try_lint() end }
  )
end)

MiniDeps.later(function()
  MiniDeps.add("stevearc/conform.nvim")

  require("conform").setup({
    formatters_by_ft = {
      -- clojure = { "zprint" },
      fish = { "fish_indent" },
      lua = { "stylua" },
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

MiniDeps.later(function()
  MiniDeps.add("PaterJason/nvim-nrepl")

  local augroup = vim.api.nvim_create_augroup("nvim_nrepl", {})
  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = augroup,
    pattern = { "clojure" },
    callback = function(_args)
      require("nrepl").init()

      local action = require("nrepl.action")
      vim.keymap.set(
        { "n", "x" },
        "<LocalLeader>e",
        "<Plug>(NreplEvalOperator)",
        { desc = "Eval", buffer = 0 }
      )
      vim.keymap.set(
        "n",
        "<LocalLeader>ee",
        action.eval_cursor,
        { desc = "Eval cursor", buffer = 0 }
      )
      vim.keymap.set("n", "<LocalLeader>lf", action.load_file, { desc = "Load file", buffer = 0 })
      vim.keymap.set("n", "<LocalLeader>ll", "<Cmd>Nrepl log<CR>", { desc = "Log", buffer = 0 })
      vim.keymap.set(
        "n",
        "<LocalLeader>ls",
        function()
          require("nrepl.prompt").open_win(true, {
            win = -1,
            vertical = false,
          })
        end,
        {
          desc = "Log split",
          buffer = 0,
        }
      )
      vim.keymap.set(
        "n",
        "<LocalLeader>lv",
        function()
          require("nrepl.prompt").open_win(true, {
            win = -1,
            vertical = true,
          })
        end,
        { desc = "Log vsplit", buffer = 0 }
      )
      vim.keymap.set(
        "n",
        "<LocalLeader>lt",
        "<Cmd>tabnew | Nrepl log<CR>",
        { desc = "Log split", buffer = 0 }
      )

      vim.keymap.set("n", "<LocalLeader>K", action.hover, { desc = "Hover lookup", buffer = 0 })
      vim.keymap.set("n", "<LocalLeader>np", action.eval_input, { desc = "Eval input", buffer = 0 })
      vim.keymap.set("n", "<LocalLeader>ni", action.interrupt, { desc = "Interrupt", buffer = 0 })
    end,
  })
end)
