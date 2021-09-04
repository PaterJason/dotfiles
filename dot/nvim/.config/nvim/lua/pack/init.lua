local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.cmd('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

return require'packer'.startup(function(use)
  use'wbthomason/packer.nvim'

  -- Pretty
  use{
    'arcticicestudio/nord-vim',
    config = function()
      require'pack.colors'
    end,
  }
  use{
    'itchyny/lightline.vim',
    config = function()
      vim.g.lightline = {colorscheme = 'nord'}
    end,
  }
  use{
    'norcalli/nvim-colorizer.lua',
    config = function()
      require'colorizer'.setup{
        '*',
        css = {css = true},
        scss = {css = true},
        '!fugitive',
        '!packer',
      }
    end
  }

  -- Key binds
  use'tpope/vim-unimpaired'
  use'christoomey/vim-tmux-navigator'
  use{
    'folke/which-key.nvim',
    config = function()
      local wk = require'which-key'
      wk.setup{}
      wk.register({}, {prefix = '<localleader>'})
    end,
  }

  -- Util
  use'tpope/vim-dispatch'
  use'tpope/vim-repeat'
  use'tpope/vim-vinegar'
  use{
    'mbbill/undotree',
    config = function()
      require'util'.set_keymap('n', '<leader>u', '<cmd>UndotreeToggle<CR>')
    end
  }

  -- Edit
  use'tpope/vim-abolish'
  use'tpope/vim-commentary'
  use{
    'junegunn/vim-easy-align',
    config = function()
      require'util'.set_keymaps{
        {'x', 'ga', '<Plug>(EasyAlign)', {}},
        {'n', 'ga', '<Plug>(EasyAlign)', {}},
      }
    end
  }

  -- Parens
  use'tpope/vim-surround'
  use{
    'guns/vim-sexp',
    requires = {'tpope/vim-sexp-mappings-for-regular-people'},
  }

  -- Git
  use'tpope/vim-fugitive'
  use{
    'lewis6991/gitsigns.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = function()
      require'gitsigns'.setup{
        preview_config = {border = 'none'},
      }
    end,
  }

  use{
    'hrsh7th/nvim-cmp',
    requires = {
      'PaterJason/cmp-conjure',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      require'pack.cmp'
    end,
  }

  -- LSP
  use{
    'neovim/nvim-lspconfig',
    requires = {'kabouzeid/nvim-lspinstall'},
    config = function()
      require'pack.lsp'
    end,
  }

  -- Tree-sitter
  use{
    'nvim-treesitter/nvim-treesitter',
    branch = '0.5-compat',
    run = ':TSUpdate',
    config = function()
      require'pack.treesitter'
    end,
  }
  use{
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/nvim-treesitter-refactor',
  }

  -- Telescope
  use{
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-symbols.nvim',
    },
    config = function()
      require'pack.telescope'
    end,
  }

  -- Clojure
  use{
    'Olical/conjure',
    config = function()
      vim.g['conjure#mapping#doc_word'] = 'K'
      vim.g['conjure#log#hud#border'] = 'none'
    end,
  }
  use{
    'clojure-vim/vim-jack-in',
    ft = 'clojure',
  }
end)
