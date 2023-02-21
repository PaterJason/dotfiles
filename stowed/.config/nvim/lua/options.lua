vim.g.mapleader = " "
vim.g.maplocalleader = [[\]]

vim.opt.autowrite = true
vim.opt.background = "light"
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.concealcursor = "nc"
vim.opt.confirm = true
vim.opt.diffopt = { "internal", "filler", "closeoff", "hiddenoff", "algorithm:minimal" }
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.ignorecase = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = { tab = "| ", trail = "·", nbsp = "+" }
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
vim.opt.showmode = false
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

local yank_augroup = vim.api.nvim_create_augroup("YankHighlight", {})
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank { timeout = 500 }
  end,
  group = yank_augroup,
})

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], {})
