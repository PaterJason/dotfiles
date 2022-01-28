vim.g.mapleader = ' '
vim.g.maplocalleader = [[\]]

vim.o.autowrite = true
vim.o.clipboard = 'unnamedplus'
vim.o.completeopt = 'menu,menuone,noselect'
vim.o.confirm = true
vim.o.expandtab = true
vim.o.fillchars = 'fold: ,diff: '
vim.o.ignorecase = true
vim.o.linebreak = true
vim.o.list = true
vim.o.mouse = 'a'
vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 0
vim.o.signcolumn = 'auto'
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.spelllang = 'en_gb'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.updatetime = 250
vim.o.wrap = false

vim.o.grepprg = 'rg --vimgrep'
vim.o.grepformat = '%f:%l:%c:%m'

vim.o.scrolloff = 4
vim.o.sidescrolloff = 8

vim.cmd 'au TextYankPost * silent! lua vim.highlight.on_yank()'
