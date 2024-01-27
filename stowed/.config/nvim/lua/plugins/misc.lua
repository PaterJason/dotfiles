---@type LazySpec
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
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
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    priority = 1000,
    config = function() require("nvim-web-devicons").setup({}) end,
  },

  -- Clojure
  {
    "Olical/conjure",
    init = function()
      vim.g["conjure#client_on_load"] = false
      vim.g["conjure#completion#omnifunc"] = false
      vim.g["conjure#highlight#enabled"] = true
      vim.g["conjure#mapping#doc_word"] = "K"
    end,
  },
  "clojure-vim/vim-jack-in",
}
