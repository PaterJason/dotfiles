MiniDeps.now(function()
  MiniDeps.add({
    source = "catppuccin/nvim",
    name = "catppuccin",
  })

  require("catppuccin").setup({
    custom_highlights = function(colors)
      return {
        NormalFloat = { bg = colors.none },
        CursorLine = { bg = colors.mantle },
      }
    end,
    integrations = {
      cmp = true,
      dap = true,
      markdown = true,
      mason = true,
      mini = { enabled = true },
      native_lsp = { enabled = true, inlay_hints = { background = true } },
      semantic_tokens = true,
      treesitter = true,
      treesitter_context = true,
    },
  })
  vim.cmd("colorscheme catppuccin")
end)

MiniDeps.now(function()
  MiniDeps.add({
    source = "stevearc/oil.nvim",
  })

  require("oil").setup({
    float = {
      border = "single",
    },
    preview = {
      border = "single",
    },
    progress = {
      border = "single",
    },
    ssh = {
      border = "single",
    },
    keymaps_help = {
      border = "single",
    },
  })
  vim.keymap.set("n", "-", "<Cmd>Oil<CR>", { desc = "Open parent directory" })
  vim.keymap.set("n", "_", "<Cmd>Oil ./<CR>", { desc = "Open current working directory" })
end)
