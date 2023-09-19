return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup {
        flavour = "latte",
        background = {
          light = "latte",
          dark = "mocha",
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          leap = true,
          markdown = true,
          mason = true,
          mini = true,
          semantic_tokens = true,
          treesitter = true,
          treesitter_context = true,
          which_key = true,

          dap = { enabled = true, enable_ui = true },
          native_lsp = { enabled = true },
          telescope = { enabled = true },
        },
      }
      vim.cmd.colorscheme "catppuccin"
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
      vim.g["conjure#completion#omnifunc"] = false
      vim.g["conjure#completion#fallback"] = nil
      vim.g["conjure#highlight#enabled"] = true
      vim.g["conjure#log#hud#border"] = "none"
      vim.g["conjure#mapping#doc_word"] = "K"
    end,
  },
  "clojure-vim/vim-jack-in",

  {
    "gpanders/nvim-parinfer",
    config = function()
      vim.g.parinfer_enabled = false
      vim.keymap.set("n", "<leader>tp", "<Cmd>ParinferToggle!<CR>", { desc = "Toggle Parinfer" })
    end,
  },
}
