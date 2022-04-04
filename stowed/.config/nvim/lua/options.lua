vim.g.mapleader = ' '
vim.g.maplocalleader = [[\]]

vim.o.autowrite = true
vim.o.clipboard = 'unnamedplus'
vim.o.completeopt = 'menu,menuone,noselect'
vim.o.confirm = true
vim.o.expandtab = true
vim.o.grepformat = '%f:%l:%c:%m'
vim.o.grepprg = 'rg --vimgrep'
vim.o.ignorecase = true
vim.o.linebreak = true
vim.o.list = true
vim.o.mouse = 'a'
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 4
vim.o.shiftwidth = 0
vim.o.showmode = false
vim.o.sidescrolloff = 4
vim.o.signcolumn = 'auto'
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.spelllang = 'en_gb'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.updatetime = 250

vim.opt.shortmess:append 'Ic'
vim.opt.listchars = { tab = '| ', trail = '·', nbsp = '+' }
vim.opt.fillchars = { fold = ' ', diff = ' ' }

local yank_augroup = vim.api.nvim_create_augroup('YankHighlight', {})
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = vim.highlight.on_yank,
  group = yank_augroup,
})
