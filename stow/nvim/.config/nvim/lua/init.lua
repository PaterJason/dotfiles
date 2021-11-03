vim.g.mapleader = ' '
vim.g.maplocalleader = [[\]]

local opts = {
  termguicolors = true,
  shell = '/bin/bash',
  hidden = true,
  swapfile = false,
  spelllang = 'en_gb',
  mouse = 'a',
  clipboard = 'unnamedplus',
  title = true,
  lazyredraw = true,
  -- colorcolumn = '80',
  number = true,
  relativenumber = true,
  joinspaces = false,
  tabstop = 2,
  softtabstop = 2,
  shiftwidth = 2,
  expandtab = true,
  ignorecase = true,
  smartcase = true,
  inccommand = 'nosplit',
  hlsearch = false,
  list = true,
  listchars = 'tab:» ,trail:·,nbsp:·',
  breakindent = true,
  breakindentopt = 'sbr',
  linebreak = true,
  showbreak = '↩',
  splitright = true,
  splitbelow = true,
  winwidth = 90,
  updatetime = 250,
  signcolumn = 'auto:3',
  completeopt = 'menu,menuone,noselect',
}

for name, value in pairs(opts) do
  vim.o[name] = value
end

vim.cmd 'au TextYankPost * silent! lua vim.highlight.on_yank()'
