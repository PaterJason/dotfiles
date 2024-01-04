---@type LazySpec
return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup {
        variant = "auto",
        dark_variant = "main",
        bold_vert_split = false,
        dim_nc_background = false,
        disable_background = false,
        disable_float_background = false,
        disable_italics = false,
      }
      vim.cmd.colorscheme "rose-pine"
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    priority = 1000,
    config = function()
      require("nvim-web-devicons").setup {}
    end,
  },

  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup {
        float = { border = "single" },
        preview = { border = "single" },
        progress = { border = "single" },
      }
      vim.keymap.set("n", "-", "<Cmd>Oil<CR>", { desc = "Open parent directory" })
      vim.keymap.set("n", "_", "<Cmd>Oil .<CR>", { desc = "Open current directory" })
    end,
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
