local g, o, opt = vim.g, vim.o, vim.opt

-- Enables the experimental Lua module loader
vim.loader.enable()

-- Disable remote plugin providers
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

-- Leader maps
g.mapleader = " "
g.maplocalleader = [[\]]

-- General
o.clipboard = "unnamedplus"
o.confirm = true
o.dictionary = "/usr/share/dict/british-english"
opt.grepformat:prepend("%f:%l:%c:%m")
o.grepprg = "rg --vimgrep --smart-case"
o.spelllang = "en_gb"
o.spelloptions = "camel"
o.swapfile = false
o.updatetime = 250
opt.diffopt:append({ "vertical", "algorithm:histogram", "indent-heuristic", "linematch:60" })

-- Appearance
o.background = "light"
o.breakindent = true
o.linebreak = true
o.showbreak = "↵ "
o.number = true
o.relativenumber = true
opt.shortmess:append("I")
o.splitbelow = true
o.splitright = true

-- Editing
o.ignorecase = true
o.infercase = true
o.smartcase = true
o.tabstop = 2
o.completeopt = "menuone,noinsert,noselect"
o.nrformats = "alpha,hex,bin,unsigned"

-- Extra UI options
o.list = true
opt.listchars = { tab = "| ", trail = "·", nbsp = "␣", extends = "…", precedes = "…" }
opt.fillchars = { eob = " ", fold = " " }
o.wildmode = "longest:full,full"

-- Folds
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldmethod = "expr"
o.foldcolumn = "auto"
o.foldlevelstart = 99
o.foldnestmax = 10
o.foldtext = ""

vim.cmd.packadd("cfilter")

-- GUI
if vim.fn.has("gui_running") == 1 then vim.o.guifont = "Monospace:h10" end
