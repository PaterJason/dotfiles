-- Bootstrap
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false
if not vim.loop.fs_access(install_path, 'W') then
  local url = 'https://github.com/wbthomason/packer.nvim'
  packer_bootstrap = vim.fn.system { 'git', 'clone', '--depth', '1', url, install_path }
  vim.cmd 'packadd packer.nvim'
end

local packer = require 'packer'
packer.startup {
  function(use)
    use 'wbthomason/packer.nvim'

    -- Visuals
    use {
      'folke/tokyonight.nvim',
      config = function()
        vim.g.tokyonight_style = 'night'
        vim.cmd 'colorscheme tokyonight'
      end,
    }
    use {
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
    }

    -- Keymaps
    use {
      'folke/which-key.nvim',
      config = function()
        require 'plugins.keymap'
      end,
    }
    use 'tpope/vim-unimpaired'
    use 'christoomey/vim-tmux-navigator'

    -- Util
    use 'tpope/vim-dispatch'
    use 'tpope/vim-repeat'
    use 'tpope/vim-vinegar'
    use 'tpope/vim-eunuch'
    use 'ggandor/lightspeed.nvim'

    -- Edit
    use 'mbbill/undotree'
    use 'tpope/vim-commentary'

    -- Parentheses
    use 'tpope/vim-surround'
    use {
      'gpanders/nvim-parinfer',
      config = function ()
        require('which-key').register({
          ['<leader>p'] = { '<cmd>ParinferToggle!<CR>', 'Toggle Parinfer'}
        }, {})
      end
    }
    use {
      'windwp/nvim-autopairs',
      after = 'nvim-cmp',
      config = function()
        require('nvim-autopairs').setup {
          disable_filetype = {
            'TelescopePrompt',
            -- Parinfer filetypes
            'clojure',
            'scheme',
            'lisp',
            'racket',
            'hy',
            'fennel',
            'janet',
            'carp',
            'wast',
            'yuck',
            'query',
          },
          check_ts = true,
          enable_check_bracket_line = false,
        }
        require('cmp').event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
      end,
    }

    -- Git
    use {
      'tpope/vim-fugitive',
      requires = { 'tpope/vim-rhubarb' },
    }
    use {
      'lewis6991/gitsigns.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('gitsigns').setup {
          preview_config = {
            border = 'solid',
          },
          signcolumn = false,
          numhl = true,
          on_attach = function()
            require('which-key').register({
              ['[c'] = { '<cmd>Gitsigns prev_hunk<CR>', 'Prev hunk' },
              [']c'] = { '<cmd>Gitsigns next_hunk<CR>', 'Next hunk' },
              ['<leader>h'] = {
                name = 'Gitsigns',
                b = { '<cmd>Gitsigns blame_line<CR>', 'Blame line' },
                d = { '<cmd>Gitsigns diffthis<CR>', 'Diffthis' },
                l = { '<cmd>Gitsigns setloclist<CR>', 'Set loclist' },
                p = { '<cmd>Gitsigns preview_hunk<CR>', 'Preview hunk' },
                r = { '<cmd>Gitsigns reset_hunk<CR>', 'Reset hunk' },
                s = { '<cmd>Gitsigns stage_hunk<CR>', 'Stage hunk' },
                u = { '<cmd>Gitsigns undo_stage_hunk<CR>', 'Undo stage hunk' },
              },
            }, {
              buffer = 0,
            })
          end,
        }
      end,
    }

    -- Completion
    use {
      'hrsh7th/nvim-cmp',
      requires = {
        'L3MON4D3/LuaSnip',
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
    }

    -- LSP
    use {
      'neovim/nvim-lspconfig',
      requires = {
        'folke/lua-dev.nvim',
        'simrat39/rust-tools.nvim',
      },
      config = function()
        require 'plugins.lsp'
      end,
    }

    use {
      'mhartington/formatter.nvim',
      config = function()
        require 'plugins.format'
      end,
    }

    -- DAP
    use {
      'mfussenegger/nvim-dap',
      requires = {
        'theHamsta/nvim-dap-virtual-text',
        'jbyuki/one-small-step-for-vimkind',
      },
      config = function()
        require 'plugins.dap'
      end,
    }

    -- Treesitter
    use {
      'nvim-treesitter/nvim-treesitter',
      requires = {
        'nvim-treesitter/nvim-treesitter-textobjects',
        'nvim-treesitter/nvim-treesitter-refactor',
      },
      run = ':TSUpdate',
      config = function()
        require 'plugins.treesitter'
      end,
    }
    use {
      'lewis6991/spellsitter.nvim',
      config = function()
        require('spellsitter').setup()
      end,
    }

    -- Telescope
    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-fzy-native.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
        'nvim-telescope/telescope-symbols.nvim',
        'nvim-telescope/telescope-dap.nvim',
      },
      config = function()
        require 'plugins.telescope'
      end,
      cmd = 'Telescope',
      module = 'telescope',
    }

    -- Clojure
    use {
      'Olical/conjure',
      config = function()
        vim.g['conjure#completion#fallback'] = nil
        vim.g['conjure#completion#omnifunc'] = nil
        vim.g['conjure#extract#tree_sitter#enabled'] = true
        vim.g['conjure#highlight#enabled'] = true
        vim.g['conjure#highlight#timeout'] = 150
        vim.g['conjure#log#hud#border'] = 'solid'
        vim.g['conjure#mapping#doc_word'] = 'K'
      end,
    }
    use 'clojure-vim/vim-jack-in'

    if packer_bootstrap then
      packer.sync()
    end
  end,
  config = {
    profile = {
      enable = true,
    },
    max_jobs = 5,
    display = { prompt_border = 'solid' },
  },
}
