MiniDeps.now(function()
  MiniDeps.add({
    source = "catppuccin/nvim",
    name = "catppuccin",
  })

  require("catppuccin").setup({
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    custom_highlights = function(colors)
      return {
        NormalFloat = { bg = colors.none },
      }
    end,
    integrations = {
      cmp = true,
      dap = true,
      gitsigns = true,
      markdown = true,
      mason = true,
      mini = { enabled = true },
      native_lsp = { enabled = true },
      semantic_tokens = true,
      treesitter = true,
      treesitter_context = true,
    },
  })
  vim.cmd.colorscheme("catppuccin")
end)

MiniDeps.now(function()
  MiniDeps.add({
    source = "nvim-tree/nvim-web-devicons",
  })
  require("nvim-web-devicons").setup({})
end)

MiniDeps.later(function()
  vim.g["conjure#client_on_load"] = false
  vim.g["conjure#completion#omnifunc"] = false
  vim.g["conjure#highlight#enabled"] = true
  vim.g["conjure#mapping#doc_word"] = "K"
  MiniDeps.add({
    source = "Olical/conjure",
  })
end)
