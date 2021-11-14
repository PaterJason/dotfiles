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
      'nvim-lualine/lualine.nvim',
      config = function()
        require('lualine').setup {
          options = {
            theme = 'github',
            icons_enabled = false,
            section_separators = '',
            component_separators = '',
          },
          extensions = { 'fugitive', 'quickfix' },
        }
      end,
    },
    {
      'projekt0n/github-nvim-theme',
      config = function()
        require('github-theme').setup {
          theme_style = 'dark',
          comment_style = 'NONE',
          keyword_style = 'NONE',
          hide_inactive_statusline = false,
          dark_float = true,
        }
        vim.cmd [[
        highlight link LspCodeLens Comment
        highlight Sneak guibg=#265459
        ]]
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
        require 'plugins.which_key'
      end,
    },
    -- Util
    'tpope/vim-dispatch',
    'tpope/vim-repeat',
    'tpope/vim-vinegar',
    'tpope/vim-eunuch',
    'justinmk/vim-sneak',
    -- Edit
    {
      'mbbill/undotree',
      cmd = 'UndotreeToggle',
    },
    'tpope/vim-abolish',
    'tpope/vim-commentary',
    'junegunn/vim-easy-align',
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
    'tpope/vim-fugitive',
    {
      'lewis6991/gitsigns.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('gitsigns').setup {
          preview_config = {
            border = 'none',
          },
          sign_priority = 11,
        }
      end,
    },
    -- Completion
    {
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
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
      requires = {
        'jose-elias-alvarez/null-ls.nvim',
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
      module = { 'dap' },
      setup = function()
        require 'plugins.dap_setup'
      end,
      config = function()
        require 'plugins.dap'
      end,
    },
    -- Treesitter
    {
      'nvim-treesitter/nvim-treesitter',
      branch = '0.5-compat',
      requires = {
        { 'nvim-treesitter/nvim-treesitter-textobjects', branch = '0.5-compat' },
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
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-fzy-native.nvim',
        'nvim-telescope/telescope-symbols.nvim',
        'nvim-telescope/telescope-dap.nvim',
      },
      cmd = 'Telescope',
      module = 'telescope',
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
        vim.g['conjure#completion#omnifunc'] = nil
      end,
    },
    'clojure-vim/vim-jack-in',
  },
  config = {
    -- profile = {
    --   enable = true,
    -- },
    display = { prompt_border = 'none' },
  },
}

if is_bootstrap then
  packer.sync()
end
