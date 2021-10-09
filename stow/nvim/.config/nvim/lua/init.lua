local opts = {
  shell = '/bin/bash',
  hidden = true,
  swapfile = false,
  spelllang = 'en_gb',
  mouse = 'a',
  clipboard = 'unnamedplus',
  title = true,
  lazyredraw = true,
  colorcolumn = '80',
  number = true,
  relativenumber = true,
  showmode = false,
  joinspaces = false,
  tabstop = 2,
  softtabstop = 2,
  shiftwidth = 2,
  expandtab = true,
  ignorecase = true,
  smartcase = true,
  inccommand = 'split',
  list = true,
  listchars = 'tab:» ,trail:·,nbsp:·',
  fillchars = 'fold: ,diff: ',
  breakindent = true,
  breakindentopt = 'sbr',
  linebreak = true,
  showbreak = '↩',
  splitright = true,
  splitbelow = true,
  winwidth = 90,
  updatetime = 100,
  signcolumn = 'auto:2',
  completeopt = 'menu,menuone,noselect',
}

for k, v in pairs(opts) do
  vim.o[k] = v
end

vim.cmd 'au TextYankPost * silent! lua vim.highlight.on_yank()'

require 'plugins'
