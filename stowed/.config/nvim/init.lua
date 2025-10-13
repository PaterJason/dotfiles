local _augroup = vim.api.nvim_create_augroup('JPConfig', {})

---@param s string
---@return string
---@nodiscard
local function gh(s) return ('https://github.com/%s'):format(s) end

vim.pack.add({
  gh('nvim-mini/mini.nvim'),
  gh('rafamadriz/friendly-snippets'),
  -- misc
  {
    src = gh('catppuccin/nvim'),
    name = 'catppuccin',
  },
  gh('stevearc/oil.nvim'),
  -- treesitter
  {
    src = gh('nvim-treesitter/nvim-treesitter'),
    version = 'main',
  },
  gh('nvim-treesitter/nvim-treesitter-context'),
  -- dev
  gh('neovim/nvim-lspconfig'),
  gh('b0o/SchemaStore.nvim'),
  -- gh('mfussenegger/nvim-lint'),
  -- gh('stevearc/conform.nvim'),
  gh('PaterJason/nvim-nrepl'),
  -- dap
  'https://codeberg.org/mfussenegger/nvim-dap',
  'https://codeberg.org/mfussenegger/nluarepl',
  gh('igorlfs/nvim-dap-view'),
  -- tpope
  gh('tpope/vim-abolish'),
  gh('tpope/vim-sleuth'),
  gh('tpope/vim-eunuch'),
  gh('tpope/vim-fugitive'),
}, {})
