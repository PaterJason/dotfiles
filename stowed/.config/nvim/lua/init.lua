vim.g.mapleader = ' '
vim.g.maplocalleader = [[\]]

vim.o.termguicolors = true
vim.o.shell = '/bin/bash'
vim.o.swapfile = false
vim.o.spelllang = 'en_gb'
vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'
vim.o.title = true
vim.o.lazyredraw = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.list = true
vim.o.listchars = 'tab:» ,trail:·,nbsp:·'
vim.o.fillchars = 'fold: ,diff: '
vim.o.breakindent = true
vim.o.breakindentopt = 'sbr'
vim.o.linebreak = true
vim.o.showbreak = '↩'
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.winwidth = 90
vim.o.updatetime = 250
vim.o.signcolumn = 'auto'
vim.o.completeopt = 'menuone,noselect'

vim.cmd 'au TextYankPost * silent! lua vim.highlight.on_yank()'
