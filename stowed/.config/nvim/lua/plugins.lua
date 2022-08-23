-- Bootstrap
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap = false
if not vim.loop.fs_access(install_path, "W") then
  local url = "https://github.com/wbthomason/packer.nvim"
  if vim.fn.system { "git", "clone", "--depth", "1", url, install_path } then
    packer_bootstrap = true
  end
  vim.cmd "packadd packer.nvim"
end

local packer = require "packer"
packer.startup {
  function(use)
    use "lewis6991/impatient.nvim"
    use "wbthomason/packer.nvim"

    use {
      "echasnovski/mini.nvim",
      config = function()
        require "plugins.mini"
      end,
    }

    use {
      "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup {
          css = { css = true },
          scss = { css = true },
          "*",
          "!fugitive",
          "!packer",
        }
      end,
    }

    -- Keymaps
    use {
      "folke/which-key.nvim",
      config = function()
        require "plugins.whichkey"
      end,
    }
    use "tpope/vim-unimpaired"
    use "christoomey/vim-tmux-navigator"

    -- Util
    use {
      "tpope/vim-dispatch",
      config = function()
        vim.g.dispatch_no_maps = 1
      end,
    }
    use "tpope/vim-sleuth"
    use "tpope/vim-repeat"
    use "tpope/vim-vinegar"
    use "tpope/vim-eunuch"
    use {
      "ggandor/leap.nvim",
      requires = "ggandor/leap-ast.nvim",
      config = function()
        require("leap").set_default_keymaps()
        vim.keymap.set({ "n", "x", "o" }, "<C-S>", function()
          require("leap-ast").leap()
        end, {})
      end,
    }

    -- Edit
    use {
      "mbbill/undotree",
      config = function()
        vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Undotree" })
      end,
    }

    -- Parentheses
    use {
      "gpanders/nvim-parinfer",
      config = function()
        vim.g.parinfer_enabled = false
        vim.keymap.set("n", "<leader>tp", "<cmd>ParinferToggle!<CR>", { desc = "Toggle Parinfer" })
      end,
    }
    use {
      "guns/vim-sexp",
      requires = "tpope/vim-sexp-mappings-for-regular-people",
      config = function()
        vim.g.sexp_enable_insert_mode_mappings = 0
      end,
    }

    -- Git
    use "tpope/vim-fugitive"
    use {
      "lewis6991/gitsigns.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require "plugins.gitsigns"
      end,
    }

    -- Completion
    use {
      "hrsh7th/nvim-cmp",
      requires = {
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
    }

    -- LSP
    use {
      "neovim/nvim-lspconfig",
      requires = {
        "jose-elias-alvarez/null-ls.nvim",
        "simrat39/inlay-hints.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "folke/lua-dev.nvim",
        "simrat39/rust-tools.nvim",
        "nanotee/sqls.nvim",
        "b0o/SchemaStore.nvim",
      },
      config = function()
        require "plugins.lsp"
      end,
    }

    -- DAP
    use {
      "mfussenegger/nvim-dap",
      requires = {
        "rcarriga/nvim-dap-ui",
        "jbyuki/one-small-step-for-vimkind",
      },
      config = function()
        require "plugins.dap"
      end,
    }

    -- Treesitter
    use {
      "nvim-treesitter/nvim-treesitter",
      requires = {
        "nvim-treesitter/playground",
        "nvim-treesitter/nvim-treesitter-context",
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
      run = ":TSUpdate",
      config = function()
        require "plugins.treesitter"
      end,
    }
    use {
      "lewis6991/spellsitter.nvim",
      config = function()
        require("spellsitter").setup()
      end,
    }

    -- Telescope
    use {
      "nvim-telescope/telescope.nvim",
      requires = {
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
    }

    -- Clojure
    use {
      "Olical/conjure",
      config = function()
        vim.g["conjure#completion#fallback"] = nil
        vim.g["conjure#completion#omnifunc"] = nil
        vim.g["conjure#extract#tree_sitter#enabled"] = true
        vim.g["conjure#highlight#enabled"] = true
        vim.g["conjure#log#hud#border"] = "none"
        vim.g["conjure#mapping#doc_word"] = "K"
      end,
    }
    use {
      "clojure-vim/vim-jack-in",
      ft = "clojure",
    }

    if packer_bootstrap then
      packer.sync()
    end
  end,
  config = {
    profile = {
      enable = false,
    },
    max_jobs = 5,
    display = { prompt_border = "none" },
  },
}

local augroup = vim.api.nvim_create_augroup("PackerCompile", {})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "plugins.lua",
  callback = function()
    vim.cmd "source <afile>"
    packer.compile()
  end,
  group = augroup,
})
