local g, o = vim.g, vim.o

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

g.query_lint_on = { "BufEnter", "InsertLeave", "TextChanged" }

-- General
o.clipboard = "unnamedplus"
o.confirm = true
o.dictionary = "/usr/share/dict/british-english"
o.grepprg = "rg --vimgrep --smart-case"
o.spelllang = "en"
o.spelloptions = "camel"
o.swapfile = false
o.updatetime = 250
o.diffopt = "internal,filler,closeoff,vertical,indent-heuristic,linematch:60,algorithm:histogram"

-- Appearance
o.background = "light"
o.breakindent = true
o.linebreak = true
o.showbreak = "↵ "
o.number = true
o.relativenumber = true
o.shortmess = "aoOTICF"
o.splitbelow = true
o.splitright = true
o.winborder = "single"

-- Editing
o.ignorecase = true
o.infercase = true
o.smartcase = true
o.wrapscan = false
o.inccommand = "split"
o.tabstop = 2
o.shiftwidth = 0
o.completeopt = "menuone,noinsert,fuzzy"
o.nrformats = "alpha,hex,bin,unsigned"

-- Extra UI options
o.list = true
o.listchars = "tab:| ,trail:·,nbsp:␣,extends:…,precedes:…"
o.fillchars = "eob: ,fold: "
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
-- vim.hl.priorities.semantic_tokens = 95

-- Diagnostics
vim.diagnostic.config({
  severity_sort = true,
  signs = false,
  float = {
    border = "single",
    header = "",
    source = true,
    title = "Diagnostics",
    title_pos = "left",
  },
  jump = {
    float = true,
    wrap = false,
  },
  virtual_text = true,
})
vim.keymap.set("n", "gK", function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = "Toggle diagnostic virtual_lines" })
vim.keymap.set(
  "n",
  "<Leader>q",
  function() vim.diagnostic.setloclist({}) end,
  { desc = "Open diagnostics list" }
)
vim.keymap.set(
  "n",
  "<Leader>Q",
  function() vim.diagnostic.setqflist({}) end,
  { desc = "Open diagnostics list" }
)

-- GUI
if vim.fn.has("gui_running") == 1 then vim.o.guifont = "Monospace:h10" end
