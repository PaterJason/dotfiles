vim.g.mapleader = " "
vim.g.maplocalleader = [[\]]

-- General
vim.opt.clipboard = "unnamedplus"
vim.opt.confirm = true
vim.opt.dictionary = "/usr/share/dict/british-english"
vim.opt.diffopt:append { "linematch:60", "vertical", "foldcolumn:0", "indent-heuristic" }
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.mouse = "a"
vim.opt.spelllang = "en_gb"
vim.opt.swapfile = false
vim.opt.updatetime = 250

-- Appearance
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = { tab = "| ", trail = "·", nbsp = "␣", extends = "…", precedes = "…" }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shortmess = "atOIc"
vim.opt.showmode = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true

vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8

-- Indent
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.tabstop = 4

-- Editing
vim.opt.completeopt = { "menu", "menuone", "noinsert" }
vim.opt.ignorecase = true
vim.opt.infercase = true
vim.opt.smartcase = true

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {})
-- vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
