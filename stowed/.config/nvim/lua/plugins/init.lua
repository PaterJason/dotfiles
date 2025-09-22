-- Commands
vim.api.nvim_create_user_command('PackUpdate', function() vim.pack.update() end, {})
vim.api.nvim_create_user_command('PackClean', function()
  ---@type string[]
  local names = {}
  for _, plug_data in ipairs(vim.pack.get()) do
    if not plug_data.active then names[#names + 1] = plug_data.spec.name end
  end
  if #names == 0 then
    vim.notify('Nothing to remove', vim.log.levels.INFO)
    return
  end
  local is_confirmed = vim.fn.confirm(
    ('These plugins will be removed:\n\n%s\n'):format(table.concat(names, '\n')),
    'Proceed? &Yes\n&No',
    1,
    'Question'
  ) == 1
  if is_confirmed then vim.pack.del(names) end
end, {})

---@param s string
---@return string
---@nodiscard
local function gh(s) return ('https://github.com/%s'):format(s) end

-- Options
vim.g.fugitive_legacy_commands = 0

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

require('plugins.mini')
require('plugins.misc')
require('plugins.treesitter')
require('plugins.dev')
require('plugins.dap')
