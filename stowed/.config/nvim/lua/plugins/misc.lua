---@type LazySpec
return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      vim.o.background = "light"
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

  -- Edit
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", "<Cmd>UndotreeToggle<CR>", { desc = "Undotree" })
    end,
  },

  -- Clojure
  {
    "Olical/conjure",
    init = function()
      vim.g["conjure#client_on_load"] = false
      vim.g["conjure#completion#omnifunc"] = false
      vim.g["conjure#highlight#enabled"] = true
      vim.g["conjure#log#hud#border"] = "solid"
      vim.g["conjure#mapping#doc_word"] = "K"
    end,
  },
  "clojure-vim/vim-jack-in",
}
