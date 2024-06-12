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
o.shiftwidth = 0
o.completeopt = "menuone,noinsert,popup"
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

vim.cmd("packadd cfilter")

-- Lower priority then treesitter (100)
-- vim.highlight.priorities.semantic_tokens = 95

-- Diagnostics
vim.diagnostic.config({
  severity_sort = true,
  signs = false,
  float = {
    border = "single",
    header = "",
    source = true,
    title = "Diagnostics",
  },
})
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
vim.keymap.set("n", "<leader>Q", vim.diagnostic.setqflist, { desc = "Open diagnostics list" })

-- GUI
if vim.fn.has("gui_running") == 1 then vim.o.guifont = "Monospace:h10" end
