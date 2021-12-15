-- Bootstrap
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.glob(install_path) == '' then
  local url = 'https://github.com/wbthomason/packer.nvim'
  vim.fn.system { 'git', 'clone', '--depth', '1', url, install_path }
  return
end

local packer = require 'packer'

packer.startup {
  {
    'lewis6991/impatient.nvim',
    'wbthomason/packer.nvim',
    {
      'nvim-lualine/lualine.nvim',
      config = function()
        require('lualine').setup {
          options = {
            theme = 'tokyonight',
            icons_enabled = false,
            section_separators = '',
            component_separators = '',
          },
          extensions = { 'fugitive', 'quickfix' },
        }
      end,
    },
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
          signcolumn = false,
          numhl = true,
        }
      end,
    },
    -- Completion
    {
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-omni',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        'PaterJason/cmp-conjure',
      },
      config = function()
        require 'plugins.cmp'
      end,
    },
    -- LSP
    {
      'neovim/nvim-lspconfig',
      requires = { 'folke/lua-dev.nvim' },
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
      run = ':TSUpdate',
      config = function()
        require 'plugins.treesitter'
      end,
    },
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
      after = 'nvim-treesitter',
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
        'nvim-telescope/telescope-ui-select.nvim',
        'nvim-telescope/telescope-symbols.nvim',
        'nvim-telescope/telescope-file-browser.nvim',
        'nvim-telescope/telescope-dap.nvim',
      },
      config = function()
        require 'plugins.telescope'
      end,
    },
    -- Rust
    {
      'simrat39/rust-tools.nvim',
      config = function()
        require('rust-tools').setup {
          tools = {
            inlay_hints = {
              show_parameter_hints = false,
            },
            hover_actions = {
              border = 'none',
            },
          },
          server = {
            settings = {
              ['rust-analyzer'] = {
                checkOnSave = {
                  command = 'clippy',
                  extraArgs = { '--', '-W', 'clippy::pedantic' },
                },
              },
            },
          },
        }
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
    max_jobs = 5,
    compile_path = vim.fn.stdpath 'config' .. '/lua/packer_compiled.lua',
    display = { prompt_border = 'none' },
  },
}

if not pcall(require, 'packer_compiled') then
  packer.sync()
end
