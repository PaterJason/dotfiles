local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority=1000,
    config = function()
      require "colour"
    end,
  },
  -- Keymaps

  {
    "folke/which-key.nvim",
    config = function()
      require "plugins.whichkey"
    end,
  },
  "tpope/vim-unimpaired",
  "christoomey/vim-tmux-navigator",

  -- Util
  {
    "tpope/vim-dispatch",
    config = function()
      vim.g.dispatch_no_maps = 1
    end,
  },
  "tpope/vim-sleuth",
  "tpope/vim-repeat",
  "tpope/vim-vinegar",
  "tpope/vim-eunuch",
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
  "tpope/vim-commentary",
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup {}
    end,
  },
  "tpope/vim-abolish",

  -- Parentheses
  {
    "kylechui/nvim-surround",
    config = true,
  },
  {
    "gpanders/nvim-parinfer",
    config = function()
      vim.g.parinfer_enabled = false
      vim.keymap.set("n", "<leader>tp", "<cmd>ParinferToggle!<CR>", { desc = "Toggle Parinfer" })
    end,
  },
  {
    "guns/vim-sexp",
    dependencies = "tpope/vim-sexp-mappings-for-regular-people",
    config = function()
      vim.g.sexp_enable_insert_mode_mappings = 0
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {
        check_ts = true,
        enable_check_bracket_line = false,
      }
      require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
    end,
  },

  -- Git
  "tpope/vim-fugitive",
  {
    "lewis6991/gitsigns.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require "plugins.gitsigns"
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "PaterJason/cmp-conjure",
      "rcarriga/cmp-dap",
    },
    config = function()
      require "plugins.cmp"
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
      "lvimuser/lsp-inlayhints.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
      "simrat39/rust-tools.nvim",
      "nanotee/sqls.nvim",
      "b0o/SchemaStore.nvim",
    },
    config = function()
      require "plugins.lsp"
    end,
  },

  -- DAP
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "jbyuki/one-small-step-for-vimkind",
    },
    config = function()
      require "plugins.dap"
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/nvim-treesitter-refactor",
    },
    build = ":TSUpdate",
    config = function()
      require "plugins.treesitter"
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    config = function()
      require "plugins.telescope"
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
}, {
  ui = {
    icons = {
      cmd = "[cmd]",
      config = "[config]",
      event = "[event]",
      ft = "[ft]",
      init = "[init]",
      keys = "[keys]",
      plugin = "[plugin]",
      runtime = "[runtime]",
      source = "[source]",
      start = "[start]",
      task = "[task]",
    },
  },
})
vim.keymap.set("n", "<leader>p", "<cmd>Lazy<CR>", { desc = "Plugins" })
