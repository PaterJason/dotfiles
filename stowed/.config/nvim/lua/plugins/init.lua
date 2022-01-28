-- Bootstrap
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false
if vim.fn.glob(install_path) == '' then
  local url = 'https://github.com/wbthomason/packer.nvim'
  packer_bootstrap = vim.fn.system { 'git', 'clone', '--depth', '1', url, install_path }
  vim.cmd 'packadd packer.nvim'
end

local packer = require 'packer'

packer.startup {
  {
    'wbthomason/packer.nvim',
    {
      'folke/tokyonight.nvim',
      config = function()
        vim.g.tokyonight_style = 'night'
        vim.cmd 'colorscheme tokyonight'
      end,
    },
    {
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup {
          css = { css = true },
          scss = { css = true },
          '*',
          '!fugitive',
          '!packer',
        }
      end,
    },
    -- Keymaps
    {
      'folke/which-key.nvim',
      config = function()
        require 'plugins.keymap'
      end,
    },
    'tpope/vim-unimpaired',
    'christoomey/vim-tmux-navigator',
    -- Util
    'tpope/vim-dispatch',
    'tpope/vim-repeat',
    'tpope/vim-vinegar',
    'tpope/vim-eunuch',
    'ggandor/lightspeed.nvim',
    -- Edit
    'mbbill/undotree',
    'tpope/vim-commentary',
    -- Parentheses
    'tpope/vim-surround',
    {
      'windwp/nvim-autopairs',
      config = function()
        require('nvim-autopairs').setup {
          enable_check_bracket_line = false,
        }
      end,
    },
    {
      'guns/vim-sexp',
      requires = 'tpope/vim-sexp-mappings-for-regular-people',
      config = function()
        vim.g.sexp_filetypes = 'clojure,scheme,lisp,fennel'
        vim.g.sexp_enable_insert_mode_mappings = 0
      end,
    },
    -- Git
    {
      'tpope/vim-fugitive',
      requires = { 'tpope/vim-rhubarb' },
    },
    {
      'lewis6991/gitsigns.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('gitsigns').setup {
          preview_config = {
            border = 'solid',
          },
          signcolumn = false,
          numhl = true,
        }
      end,
    },
    -- Completion
    {
      'hrsh7th/nvim-cmp',
      requires = {
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        'PaterJason/cmp-conjure',
      },
      config = function()
        require 'plugins.completion'
      end,
    },
    -- LSP
    {
      'neovim/nvim-lspconfig',
      requires = {
        'nanotee/nvim-lsp-basics',
        'jose-elias-alvarez/null-ls.nvim',
        'folke/lua-dev.nvim',
        'simrat39/rust-tools.nvim',
      },
      config = function()
        require 'plugins.lsp'
      end,
    },
    -- DAP
    {
      'mfussenegger/nvim-dap',
      requires = {
        'jbyuki/one-small-step-for-vimkind',
      },
      config = function()
        require 'plugins.dap'
      end,
    },
    -- Treesitter
    {
      'nvim-treesitter/nvim-treesitter',
      requires = {
        'nvim-treesitter/nvim-treesitter-textobjects',
        'nvim-treesitter/nvim-treesitter-refactor',
      },
      run = ':TSUpdate',
      config = function()
        require 'plugins.treesitter'
      end,
    },
    {
      'lewis6991/spellsitter.nvim',
      config = function()
        require('spellsitter').setup()
      end,
    },
    -- Telescope
    {
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-fzy-native.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
        'nvim-telescope/telescope-symbols.nvim',
        'nvim-telescope/telescope-project.nvim',
      },
      config = function()
        require 'plugins.telescope'
      end,
      cmd = 'Telescope',
      module = 'telescope',
    },
    -- Clojure
    {
      'Olical/conjure',
      config = function()
        vim.g['conjure#mapping#doc_word'] = 'K'
        vim.g['conjure#log#hud#border'] = 'solid'
        vim.g['conjure#completion#omnifunc'] = nil
      end,
    },
    'clojure-vim/vim-jack-in',
  },
  config = {
    profile = {
      enable = true,
    },
    max_jobs = 5,
    display = { prompt_border = 'solid' },
  },
}

if packer_bootstrap then
  packer.sync()
end
