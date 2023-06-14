vim.g.mapleader = " "
vim.g.maplocalleader = [[\]]

vim.opt.autowrite = true
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.confirm = true
vim.opt.diffopt:append { "hiddenoff", "indent-heuristic", "linematch:60", "algorithm:histogram" }
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.ignorecase = true
vim.opt.infercase = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = { tab = "| ", trail = "·", nbsp = "␣", extends = "…", precedes = "…" }
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.showmode = false
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "auto"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.spelllang = "en_gb"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.updatetime = 250

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {})
