local g, o, opt = vim.g, vim.o, vim.opt

-- Disable remote plugin providers
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

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
o.updatetime = 500
opt.diffopt:append({ 'vertical', 'algorithm:histogram' })

-- Appearance
o.background = 'light'
o.list = true
o.number = true
o.pumborder = 'single'
o.quickfixtextfunc = [[v:lua.require'vcall'.qftf]]
o.relativenumber = true
o.shortmess = 'aoOTICF'
o.splitbelow = true
o.splitright = true
o.statusline = require('statusline').stl
o.winborder = 'single'
o.wrap = false
opt.listchars = {
  tab = '| ',
  trail = '·',
  nbsp = '␣',
  extends = '…',
  precedes = '…',
}
opt.fillchars = {
  eob = ' ',
  fold = ' ',
  foldsep = ' ',
  foldinner = ' ',
}

-- Editing
o.ignorecase = true
o.smartcase = true
o.infercase = true
o.inccommand = 'split'
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 0
o.nrformats = 'alpha,hex,bin,blank'
if vim.fn.executable('rg') == 1 then
  o.findfunc = [[v:lua.require'vcall'.rg_ffu]]
  o.grepprg = 'rg --vimgrep --smart-case'
end

-- Folds
o.foldcolumn = 'auto'
o.foldlevelstart = 99
o.foldtext = ''

-- Completion
o.complete = 'o,.'
o.completeopt = 'menuone,noinsert,fuzzy'
o.pumheight = 15
o.wildmode = 'noselect,full'
o.wildoptions = 'pum,tagfile,fuzzy'

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
  group = 'JPConfig',
  desc = 'Wildmenu autocompletion',
})
vim.cmd([[
  cnoremap <expr> <Up>    wildmenumode() ? "\<C-E>\<Up>"    : "\<Up>"
  cnoremap <expr> <Down>  wildmenumode() ? "\<C-E>\<Down>"  : "\<Down>"
  cnoremap <expr> <Left>  wildmenumode() ? "\<C-E>\<Left>"  : "\<Left>"
  cnoremap <expr> <Right> wildmenumode() ? "\<C-E>\<Right>" : "\<Right>"
]])

-- Lower priority then treesitter (100)
-- vim.hl.priorities.semantic_tokens = 95
vim.cmd([[
hi link @lsp.type.string.lua @lsp
]])

-- Diagnostics
vim.diagnostic.config({
  signs = {
    text = require('icons').diagnostic,
  },
  virtual_text = {
    current_line = true,
  },
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
require('vim._extui').enable({
  enable = true,
  msg = {
    ---@type 'cmd'|'msg'
    target = 'msg',
    timeout = 4000,
  },
})

-- Autocommands
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function(_args) vim.hl.on_yank({ timeout = 250 }) end,
  group = 'JPConfig',
  desc = 'Highlight on yank',
})
vim.api.nvim_create_autocmd('FileType', {
  group = 'JPConfig',
  desc = 'Close with <q>',
  pattern = {
    'qf',
    'dap-float',
  },
  callback = function(args) vim.keymap.set('n', 'q', '<Cmd>q<CR>', { buffer = args.buf }) end,
})

--- ftplugin options, maybe move
g.clojure_align_subforms = 1
g.clojure_fuzzy_indent_patterns = { '^with', '^def', '^let', '^comment$' }
g.clojure_maxlines = 0
g.query_lint_on = { 'BufEnter', 'InsertLeave', 'TextChanged' }
