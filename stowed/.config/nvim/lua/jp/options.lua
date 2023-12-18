local g, o, opt = vim.g, vim.o, vim.opt

g.mapleader = " "
g.maplocalleader = [[\]]

-- General
o.clipboard = "unnamedplus"
o.confirm = true
o.dictionary = "/usr/share/dict/british-english"
opt.grepformat:prepend "%f:%l:%c:%m"
o.grepprg = "rg --vimgrep"
o.spelllang = "en_gb"
o.swapfile = false
o.updatetime = 250
opt.diffopt:append { "vertical", "algorithm:patience", "linematch:60" }

-- Appearance
o.background = "light"
o.breakindent = true
o.linebreak = true
o.showbreak = "↵ "
o.number = true
o.relativenumber = true
o.splitbelow = true
o.splitright = true
o.splitkeep = "screen"
o.wrap = false

-- Editing
o.ignorecase = true
o.infercase = true
o.smartcase = true

o.completeopt = "menuone,noinsert,noselect"
o.nrformats = "alpha,hex,bin,unsigned"

-- Extra UI options
o.pumheight = 16
o.listchars = "tab:| ,trail:·,extends:…,precedes:…,nbsp:␣"
o.list = true
o.fillchars = "eob: ,fold: "
o.wildmode = "longest:full,full"

-- Folds
o.foldcolumn = "auto"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldtext = "v:lua.require'jp.call'.foldtext()"

vim.cmd.packadd "cfilter"

-- GUI
if vim.fn.has("gui_running") == 1 then
  vim.o.guifont = "Monospace:h10"
end
