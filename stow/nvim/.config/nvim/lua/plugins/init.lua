local packer = require 'packer'

packer.startup {
  {
    'wbthomason/packer.nvim',
    -- Visual
    {
      'arcticicestudio/nord-vim',
      config = function()
        vim.g.nord_italic = 1
        vim.g.nord_italic_comments = 1
        vim.g.nord_underline = 1
        vim.cmd 'colorscheme nord'
        vim.cmd 'highlight link LspReferenceText Underline'
        vim.cmd 'highlight link LspReferenceRead Underline'
        return vim.cmd 'highlight link LspReferenceWrite Underline'
      end,
    },
    {
      'itchyny/lightline.vim',
      config = function()
        vim.g.lightline = { colorscheme = 'nord' }
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
    'tpope/vim-unimpaired',
    'christoomey/vim-tmux-navigator',
    {
      'folke/which-key.nvim',
      config = function()
        local wk = require 'which-key'
        wk.setup {}
        wk.register({}, { prefix = '<localleader>' })
      end,
    },
    -- Util
    'tpope/vim-dispatch',
    'tpope/vim-repeat',
    'tpope/vim-vinegar',
    -- Edit
    {
      'mbbill/undotree',
      config = function()
        require('util').keymap('n', '<leader>u', '<cmd>UndotreeToggle<CR>')
      end,
    },
    'tpope/vim-abolish',
    'tpope/vim-commentary',
    {
      'junegunn/vim-easy-align',
      config = function()
        require('util').keymaps {
          { 'x', 'ga', '<Plug>(EasyAlign)', {} },
          { 'n', 'ga', '<Plug>(EasyAlign)', {} },
        }
      end,
    },
    -- Parens
    'tpope/vim-surround',
    {
      'guns/vim-sexp',
      requires = 'tpope/vim-sexp-mappings-for-regular-people',
      config = function()
        vim.g.sexp_filetypes = 'clojure,scheme,lisp,fennel'
      end,
    },
    -- Git
    'tpope/vim-fugitive',
    {
      'lewis6991/gitsigns.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('gitsigns').setup { preview_config = { border = 'none' } }
      end,
    },
    -- Completion
    {
      'hrsh7th/nvim-cmp',
      requires = {
        'PaterJason/cmp-conjure',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
      },
      config = function()
        require 'plugins.cmp'
      end,
    },
    -- LSP
    {
      'neovim/nvim-lspconfig',
      config = function()
        require 'plugins.lsp'
      end,
    },
    -- Treesitter
    {
      'nvim-treesitter/nvim-treesitter',
      branch = '0.5-compat',
      requires = {
        'nvim-treesitter/nvim-treesitter-textobjects',
        'nvim-treesitter/nvim-treesitter-refactor',
        'nvim-treesitter/playground',
      },
      run = ':TSUpdate',
      config = function()
        require 'plugins.treesitter'
      end,
    },
    -- Telescope
    {
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-fzy-native.nvim',
        'nvim-telescope/telescope-symbols.nvim',
      },
      config = function()
        require 'plugins.telescope'
      end,
    },
    -- Clojure
    {
      'Olical/conjure',
      config = function()
        vim.g['conjure#mapping#doc_word'] = 'K'
        vim.g['conjure#log#hud#border'] = 'none'
      end,
    },
    'clojure-vim/vim-jack-in',
  },
  config = { display = { prompt_border = 'none' } },
}
