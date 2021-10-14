-- Bootstrap
local url = 'https://github.com/wbthomason/packer.nvim'
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.glob(install_path) == '' then
  vim.fn.system { 'git', 'clone', '--depth', '1', url, install_path }
  is_bootstrap = true
end

local packer = require 'packer'

packer.startup {
  {
    'wbthomason/packer.nvim',
    {
      'shaunsingh/nord.nvim',
      config = function()
        vim.g.nord_borders = true
        require('nord').set()
        vim.cmd [[
        highlight link LspCodeLens Comment
        ]]
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
      cmd = 'UndotreeToggle',
      setup = function()
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
    'tpope/vim-fugitive',
    'TimUntersberger/neogit',
    {
      'lewis6991/gitsigns.nvim',
      requires = 'nvim-lua/plenary.nvim',
      cmd = 'Neogit',
      module = 'neogit',
      setup = function()
        require('util').keymap('n', '<leader>g', '<cmd>Neogit<CR>')
      end,
      config = function()
        require('gitsigns').setup {}
      end,
    },
    -- Completion
    {
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/vim-vsnip',
        'PaterJason/cmp-conjure',
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
    -- DAP
    {
      'mfussenegger/nvim-dap',
      requires = {
        'jbyuki/one-small-step-for-vimkind',
        'rcarriga/nvim-dap-ui',
      },
      config = function()
        require 'plugins.dap'
      end,
    },
    -- Treesitter
    {
      'nvim-treesitter/nvim-treesitter',
      branch = '0.5-compat',
      requires = {
        'nvim-treesitter/nvim-treesitter-textobjects',
        'nvim-treesitter/nvim-treesitter-refactor',
        'nvim-telescope/telescope-dap.nvim',
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
      cmd = 'Telescope',
      module = 'telescope',
      setup = function()
        require 'plugins.telescope_setup'
      end,
      config = function()
        require 'plugins.telescope'
      end,
    },
    -- Clojure
    {
      'Olical/conjure',
      config = function()
        vim.g['conjure#mapping#doc_word'] = 'K'
      end,
    },
    'clojure-vim/vim-jack-in',
  },
  config = {
    -- profile = {
    --   enable = true,
    --   threshold = 1,
    -- },
    display = { prompt_border = 'single' },
  },
}

if is_bootstrap then
  packer.sync()
end
