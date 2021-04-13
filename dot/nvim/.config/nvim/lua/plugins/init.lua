local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.cmd('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end

vim.cmd'autocmd BufWritePost */lua/pack/init.lua PackerCompile'

return require'packer'.startup(function(use)
  use'wbthomason/packer.nvim'

  -- Pretty
  use{
    'arcticicestudio/nord-vim',
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
  use{
    'liuchengxu/vim-which-key',
    config = function()
      require'util'.set_keymaps{
        {'n', '<leader>', [[<cmd>WhichKey '<leader>'<CR>]]},
        {'v', '<leader>', [[<cmd>WhichKeyVisual '<leader>'<CR>]]},
        {'n', '<localleader>', [[<cmd>WhichKey '<localleader>'<CR>]]},
        {'v', '<localleader>', [[<cmd>WhichKeyVisual '<localleader>'<CR>]]},
      }
    end,
  }
  use{
    'tmux-plugins/vim-tmux-focus-events',
    requires = {'christoomey/vim-tmux-navigator'},
  }

  -- Util
  use'tpope/vim-dispatch'
  use'tpope/vim-repeat'
  use'tpope/vim-vinegar'
  -- use'sheerun/vim-polyglot'
  use{
    'simnalamburt/vim-mundo',
    config = function()
      require'util'.set_keymap('n', '<leader>u', '<cmd>MundoToggle<CR>')
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
  use{
    'mhinz/vim-grepper',
    config = function()
      require'util'.set_keymaps{
        {'n', '<leader>G', '<cmd>Grepper<CR>'},
        {'x', '<leader>G', '<plug>(GrepperOperator)'},
      }
    end,
  }

  -- Edit
  use'tpope/vim-abolish'
  use'tpope/vim-commentary'

  -- Parens
  use{
    'machakann/vim-sandwich',
    config = function()
      vim.cmd'runtime macros/sandwich/keymap/surround.vim'
    end,
  }
  use{
    'guns/vim-sexp',
    requires = {'tpope/vim-sexp-mappings-for-regular-people'}
  }

  -- Git
  use{
    'tpope/vim-fugitive',
    config = function()
      require'util'.set_keymaps{
        {'n', '<leader>gb', '<cmd>Git blame<CR>'},
        {'n', '<leader>gg', '<cmd>Git<CR>'},
      }
    end,
  }
  use{
    'mhinz/vim-signify',
    config = function()
      require'util'.set_keymaps{
        {'n', '<leader>gd', '<cmd>SignifyDiff<CR>'},
        {'n', '<leader>gp', '<cmd>SignifyHunkDiff<CR>'},
        {'n', '<leader>gu', '<cmd>SignifyHunkUndo<CR>'},
        {'o', 'ic', '<plug>(signify-motion-inner-pending)'},
        {'x', 'ic', '<plug>(signify-motion-inner-visual)'},
        {'o', 'ac', '<plug>(signify-motion-outer-pending)'},
        {'x', 'ac', '<plug>(signify-motion-outer-visual)'},
      }
    end
  }

  -- IDE
  use{
    'neovim/nvim-lspconfig',
    config = function()
      require'plugins.lsp'
    end,
  }
  use{
    'hrsh7th/nvim-compe',
    requires = {'tami5/compe-conjure'},
    config = function()
      require'plugins.compe'
    end,
  }

  use{
    'norcalli/snippets.nvim',
    config = function()
      require'plugins.snippets'
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
  use'clojure-vim/vim-jack-in'
end)
