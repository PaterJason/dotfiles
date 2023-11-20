local g, o, opt = vim.g, vim.o, vim.opt

g.mapleader = " "
g.maplocalleader = [[\]]

-- General
o.backup = false
o.writebackup = false
o.mouse = "a"

o.clipboard = "unnamedplus"
o.confirm = true
o.dictionary = "/usr/share/dict/british-english"
opt.grepformat:prepend "%f:%l:%c:%m"
o.grepprg = "rg --vimgrep"
o.spelllang = "en_gb"
o.swapfile = false
o.updatetime = 500
opt.diffopt:append { "linematch:60", "vertical", "foldcolumn:0", "indent-heuristic" }

-- Appearance
o.breakindent = true
o.linebreak = true
o.number = true
o.relativenumber = true
o.splitbelow = true
o.splitright = true
o.termguicolors = true

o.wrap = false
o.fillchars = "eob: "

-- Editing
o.ignorecase = true
o.incsearch = true
o.infercase = true
o.smartcase = true
o.smartindent = true

o.completeopt = "menuone,noinsert,noselect"

opt.shortmess:append "WcC"
o.splitkeep = "screen"

-- Extra UI options
o.pumheight = 16
o.listchars = "tab:| ,trail:·,extends:…,precedes:…,nbsp:␣"
o.list = true

-- Folds
o.foldcolumn = "auto"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldtext = "v:lua.vim.treesitter.foldtext()"

vim.cmd.packadd "cfilter"
