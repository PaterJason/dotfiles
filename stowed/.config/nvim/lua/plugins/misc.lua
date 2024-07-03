MiniDeps.now(function()
  MiniDeps.add({
    source = "catppuccin/nvim",
    name = "catppuccin",
  })

  require("catppuccin").setup({
    custom_highlights = function(colors)
      return {
        NormalFloat = { bg = colors.none },
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
