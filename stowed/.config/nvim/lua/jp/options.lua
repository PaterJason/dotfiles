local g, o, opt = vim.g, vim.o, vim.opt
local augroup = vim.api.nvim_create_augroup('JPConfig', {})

-- Enables the experimental Lua module loader
vim.loader.enable()

-- Disable remote plugin providers
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

-- Leader maps
g.mapleader = ' '
g.maplocalleader = [[\]]

-- General
o.clipboard = 'unnamedplus'
o.confirm = true
o.dictionary = '/usr/share/dict/british-english'
o.spelllang = 'en'
o.spelloptions = 'camel'
o.swapfile = false
o.updatetime = 250
opt.diffopt:append({ 'vertical', 'algorithm:histogram' })
o.exrc = true

-- Appearance
o.background = 'light'
o.number = true
o.relativenumber = true
o.shortmess = 'aoOTICF'
o.splitbelow = true
o.splitright = true
o.winborder = 'single'
o.wrap = false

-- Editing
o.ignorecase = true
o.smartcase = true
o.infercase = true
o.inccommand = 'split'
o.tabstop = 2
o.shiftwidth = 0
if vim.fn.has('nvim-0.12') == 1 then o.complete = 'o,.' end
o.completeopt = 'menuone,noinsert,fuzzy'
o.nrformats = 'alpha,hex,bin,blank'

-- Extra UI options
o.list = true
o.listchars = 'tab:| ,trail:·,nbsp:␣,extends:…,precedes:…'
o.fillchars = 'eob: ,fold: '
o.wildmode = 'noselect,full'
o.wildoptions = 'pum,tagfile,fuzzy'
if vim.fn.executable('rg') == 1 then
  o.grepprg = 'rg --vimgrep'
  o.findfunc = [[v:lua.require'func'.RgFfu]]
end

-- Folds
o.foldcolumn = 'auto'
o.foldlevelstart = 99
o.foldnestmax = 10
o.foldtext = ''

vim.cmd('packadd cfilter')

-- Lower priority then treesitter (100)
vim.hl.priorities.semantic_tokens = 95

-- Diagnostics
vim.diagnostic.config({
  float = {
    scope = 'cursor',
    header = '',
    source = true,
    title = 'Diagnostics',
    title_pos = 'left',
  },
  jump = {
    on_jump = function(_diagnostic, _bufnr) vim.diagnostic.open_float({ focus = false }) end,
  },
})

vim.keymap.set('n', 'gK', function()
  local new_config = not vim
    .diagnostic
    .config() --[[@cast -?]]
    .virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })

vim.keymap.set(
  'n',
  '<Leader>q',
  function() vim.diagnostic.setloclist({}) end,
  { desc = 'Open diagnostics list' }
)
vim.keymap.set(
  'n',
  '<Leader>Q',
  function() vim.diagnostic.setqflist({}) end,
  { desc = 'Open diagnostics list' }
)

-- GUI
if vim.fn.has('gui_running') == 1 then o.guifont = 'Monospace:h10' end
if vim.fn.has('nvim-0.12') == 1 then require('vim._extui').enable({
  enable = true,
}) end

-- Autocommands
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function(_args) vim.hl.on_yank({ timeout = 250 }) end,
  group = augroup,
  desc = 'Highlight on yank',
})
if vim.fn.has('nvim-0.12') == 1 then
  vim.api.nvim_create_autocmd('CmdlineChanged', {
    callback = vim.schedule_wrap(function(_args)
      local type = vim.fn.getcmdcompltype()
      if
        vim.fn.wildmenumode() == 0
        and not vim.startswith(type, 'custom,')
        and not vim.startswith(type, 'customlist,')
      then
        vim.fn.wildtrigger()
      end
    end),
    group = augroup,
    desc = 'Wildmenu autocompletion',
  })
  vim.cmd([[
  cnoremap <expr> <Up>   wildmenumode() ? "\<C-E>\<Up>"   : "\<Up>"
  cnoremap <expr> <Down> wildmenumode() ? "\<C-E>\<Down>" : "\<Down>"
]])
end

--- ftplugin options, maybe move
g.clojure_align_subforms = 1
g.clojure_fuzzy_indent_patterns = { '^with', '^def', '^let', '^comment$' }
g.clojure_maxlines = 0
g.query_lint_on = { 'BufEnter', 'InsertLeave', 'TextChanged' }
