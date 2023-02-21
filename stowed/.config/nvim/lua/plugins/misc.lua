return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require "colour"
    end,
  },
  -- Keymaps
  "christoomey/vim-tmux-navigator",

  -- Util
  {
    "ggandor/leap.nvim",
    dependencies = {
      "ggandor/leap-ast.nvim",
      "ggandor/flit.nvim",
    },
    config = function()
      require("leap").set_default_keymaps()
      vim.keymap.set({ "n", "x", "o" }, "<C-S>", function()
        require("leap-ast").leap()
      end, {})
      require("flit").setup {}
    end,
  },

  -- Edit
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Undotree" })
    end,
  },

  -- Clojure
  {
    "Olical/conjure",
    config = function()
      vim.g["conjure#completion#fallback"] = nil
      vim.g["conjure#completion#omnifunc"] = nil
      vim.g["conjure#extract#tree_sitter#enabled"] = true
      vim.g["conjure#highlight#enabled"] = true
      vim.g["conjure#mapping#doc_word"] = "K"
    end,
  },
  "clojure-vim/vim-jack-in",
}
