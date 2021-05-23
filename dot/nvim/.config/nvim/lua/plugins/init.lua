local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.cmd('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

vim.cmd'autocmd BufWritePost */plugins/init.lua PackerCompile'

return require'packer'.startup(function(use)
  use'wbthomason/packer.nvim'

  -- Pretty
  use{
    'arcticicestudio/nord-vim',
    requires = {'folke/lsp-colors.nvim'},
    config = function()
      require'plugins.colors'
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
        scss = { css = true},
        '!fugitive',
        '!packer',
      }
    end
  }

  -- Key binds
  use'tpope/vim-unimpaired'
  use'christoomey/vim-tmux-navigator'
  use {
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

  -- Navigation
  use{
    'justinmk/vim-sneak',
    config = function()
      vim.cmd'hi link Sneak Search'
      vim.cmd'hi link SneakScope Comment'
    end,
  }

  -- Edit
  use'tpope/vim-abolish'
  use'b3nj5m1n/kommentary'

  -- Parens
  use{
    'machakann/vim-sandwich',
    config = function()
      vim.cmd'runtime macros/sandwich/keymap/surround.vim'
    end,
  }
  use{
    'guns/vim-sexp',
    requires = {'tpope/vim-sexp-mappings-for-regular-people'},
  }
  use{
    'windwp/nvim-autopairs',
    config = function()
      require'nvim-autopairs'.setup()
    end,
  }

  -- Git
  use'tpope/vim-fugitive'
  use {
    'lewis6991/gitsigns.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = function()
      require('gitsigns').setup()
    end,
    after = 'nord-vim',
  }

  -- IDE
  use{
    'neovim/nvim-lspconfig',
    requires = {'kabouzeid/nvim-lspinstall'},
    config = function()
      require'plugins.lsp'
    end,
  }
  use{
    'hrsh7th/nvim-compe',
    requires = {'tami5/compe-conjure', 'hrsh7th/vim-vsnip'},
    config = function()
      require'plugins.compe'
    end,
  }

  use{
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require'plugins.treesitter'
    end,
  }
  use{
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/nvim-treesitter-refactor',
    after = 'nvim-treesitter'
  }

  use{
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-symbols.nvim',
    },
    config = function()
      require'plugins.telescope'
    end,
  }

  -- Clojure
  use{
    'Olical/conjure',
    config = function()
      vim.g['conjure#mapping#doc_word'] = 'K'
    end,
  }
  use{
    'clojure-vim/clojure.vim',
    'clojure-vim/vim-jack-in',
    ft = 'clojure',
  }
end)
