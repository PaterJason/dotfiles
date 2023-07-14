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
    opts = {},
  },
  -- Keymaps
  "christoomey/vim-tmux-navigator",

  -- Util
  {
    "ggandor/leap.nvim",
    dependencies = {
      "ggandor/leap-ast.nvim",
    },
    config = function()
      require("leap").set_default_keymaps()
      vim.keymap.set({ "n", "x", "o" }, "<C-S>", function()
        require("leap-ast").leap()
      end, {})
    end,
  },

  -- Edit
  {
    "mbbill/undotree",
    keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Undotree" } },
  },

  -- Clojure
  {
    "Olical/conjure",
    init = function()
      vim.g["conjure#completion#fallback"] = nil
      vim.g["conjure#completion#omnifunc"] = nil
      vim.g["conjure#extract#tree_sitter#enabled"] = true
      vim.g["conjure#highlight#enabled"] = true
      vim.g["conjure#log#hud#border"] = "none"
      vim.g["conjure#mapping#doc_word"] = "K"
      vim.g["conjure#completion#omnifunc"] = false
    end,
  },
  "clojure-vim/vim-jack-in",

  {
    "gpanders/nvim-parinfer",
    config = function()
      vim.g.parinfer_enabled = false
      vim.keymap.set("n", "<leader>tp", "<cmd>ParinferToggle!<CR>", { desc = "Toggle Parinfer" })
    end,
  },
}
