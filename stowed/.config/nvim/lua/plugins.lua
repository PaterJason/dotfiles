-- Bootstrap
local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap = false
if not vim.loop.fs_access(install_path, "W") then
  local url = "https://github.com/wbthomason/packer.nvim"
  if vim.fn.system { "git", "clone", "--depth", "1", url, install_path } then
    packer_bootstrap = true
  end
  vim.cmd.packadd "packer.nvim"
end

local packer = require "packer"
packer.startup {
  function(use)
    use "lewis6991/impatient.nvim"
    use "wbthomason/packer.nvim"

    use {
      "catppuccin/nvim",
      config = function()
        require "colour"
      end,
    }

    -- use {
    --   "NvChad/nvim-colorizer.lua",
    --   config = function()
    --     require("colorizer").setup {
    --       filetypes = {
    --         "*",
    --         "!fugitive",
    --         "!mason",
    --         "!packer",
    --       },
    --     }
    --   end,
    -- }

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
      requires = {
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
    }

    -- Edit
    use {
      "mbbill/undotree",
      config = function()
        vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Undotree" })
      end,
    }
    use "tpope/vim-commentary"
    use {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup {}
      end,
    }
    use "tpope/vim-abolish"

    -- Parentheses
    use {
      "kylechui/nvim-surround",
      config = function()
        require("nvim-surround").setup {}
      end,
    }
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
    use {
      "windwp/nvim-autopairs",
      after = "nvim-cmp",
      config = function()
        require("nvim-autopairs").setup {
          check_ts = true,
          enable_check_bracket_line = false,
        }
        require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
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
        "nvim-treesitter/nvim-treesitter-refactor",
      },
      run = ":TSUpdate",
      config = function()
        require "plugins.treesitter"
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
        vim.g["conjure#mapping#doc_word"] = "K"
      end,
    }
    use {
      "clojure-vim/vim-jack-in",
      ft = "clojure",
    }

    -- REST
    use {
      "NTBBloodbath/rest.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("rest-nvim").setup {}
        vim.keymap.set("n", "<leader>cr", "<Plug>RestNvim", { desc = "Run the request under the cursor" })
        vim.keymap.set("n", "<leader>cp", "<Plug>RestNvimPreview", { desc = "Preview the request cURL command" })
        vim.keymap.set("n", "<leader>cl", "<Plug>RestNvimLast", { desc = "Re-run the last request" })
      end,
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
    display = { prompt_border = "single" },
  },
}

local augroup = vim.api.nvim_create_augroup("PackerCompile", {})
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "plugins.lua",
  callback = function()
    vim.cmd.source "<afile>"
    packer.compile()
  end,
  group = augroup,
})
