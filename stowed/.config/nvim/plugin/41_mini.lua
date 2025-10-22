require('mini.extra').setup({})

require('mini.ai').setup({
  n_lines = 100,
  search_method = 'cover',
  mappings = {
    around_next = '',
    inside_next = '',
    around_last = '',
    inside_last = '',
  },
  custom_textobjects = {
    B = MiniExtra.gen_ai_spec.buffer(),
    D = MiniExtra.gen_ai_spec.diagnostic(),
    I = MiniExtra.gen_ai_spec.indent(),
    L = MiniExtra.gen_ai_spec.line(),
    N = MiniExtra.gen_ai_spec.number(),
  },
})

require('mini.align').setup({})

require('mini.basics').setup({
  options = { basic = false },
  mappings = { basic = false, option_toggle_prefix = 'yo' },
  autocommands = { basic = false },
})

require('mini.bracketed').setup({
  buffer = { suffix = '' }, -- built in
  comment = { suffix = '/' },
  -- conflict = { suffix = 'x' },
  diagnostic = { suffix = '' }, -- built in
  -- file = { suffix = 'f' },
  -- indent = { suffix = 'i' },
  -- jump = { suffix = 'j' },
  location = { suffix = '' }, -- built in
  oldfile = { suffix = '' },
  quickfix = { suffix = '' }, -- built in
  -- treesitter = { suffix = 't' },
  -- undo = { suffix = 'u' },
  -- window = { suffix = 'w' },
  -- yank = { suffix = 'y' },
})

require('mini.bufremove').setup({})
vim.keymap.set('n', '<Leader>bd', MiniBufremove.delete, { desc = 'Delete buffer' })
vim.keymap.set('n', '<Leader>bw', MiniBufremove.wipeout, { desc = 'Wipeout buffer' })

local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },
    { mode = 'n', keys = '<LocalLeader>' },
    { mode = 'x', keys = '<LocalLeader>' },
    -- `[` and `]` keys
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },
    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },
    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },
    -- Registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },
    -- Window commands
    { mode = 'n', keys = '<C-w>' },
    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
    -- MiniBasics
    { mode = 'n', keys = 'yo' },
  },
  clues = {
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
  window = {
    config = {
      width = 'auto',
    },
  },
})

require('mini.completion').setup({})
vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })

require('mini.diff').setup({})
vim.keymap.set(
  'n',
  '<Leader>td',
  function() MiniDiff.toggle_overlay(0) end,
  { desc = 'Toggle diff overlay' }
)

require('mini.files').setup({
  mappings = {
    go_in = '',
    go_in_plus = '<CR>',
    go_out = '',
    go_out_plus = '-',
    trim_left = '',
    trim_right = '',
  },
  windows = {
    -- Maximum number of windows to show side by side
    max_number = 1,
    width_focus = 80,
  },
})
vim.keymap.set(
  'n',
  '-',
  function() MiniFiles.open(vim.api.nvim_buf_get_name(0), false) end,
  { desc = 'Open parent directory' }
)
vim.keymap.set(
  'n',
  '_',
  function() MiniFiles.open(nil, false) end,
  { desc = 'Open current working directory' }
)

---@param params table
---@param _willMethod vim.lsp.protocol.Method.ClientToServer.Request
---@param didMethod vim.lsp.protocol.Method.ClientToServer.Notification
local function wsFile(params, _willMethod, didMethod)
  -- for _, client in ipairs(vim.lsp.get_clients({ method = willMethod })) do
  --   client:request(willMethod, params, function(_err, result, _context, _config)
  --     if result ~= nil then vim.lsp.util.apply_workspace_edit(result, client.offset_encoding) end
  --   end)
  -- end
  for _, client in ipairs(vim.lsp.get_clients({ method = didMethod })) do
    client:notify(didMethod, params)
  end
end
vim.api.nvim_create_autocmd('User', {
  desc = 'Notify LSPs that a file was renamed',
  pattern = { 'MiniFilesActionRename', 'MiniFilesActionMove' },
  callback = function(args)
    ---@type lsp.RenameFilesParams
    local params = {
      files = {
        { oldUri = vim.uri_from_fname(args.data.from), newUri = vim.uri_from_fname(args.data.to) },
      },
    }
    wsFile(params, 'workspace/willRenameFiles', 'workspace/didRenameFiles')
  end,
})

vim.api.nvim_create_autocmd('User', {
  desc = 'Notify LSPs that a file was created',
  pattern = { 'MiniFilesActionCreate', 'MiniFilesActionCopy' },
  callback = function(args)
    ---@type lsp.CreateFilesParams
    local params = { files = { { uri = vim.uri_from_fname(args.data.to) } } }
    wsFile(params, 'workspace/willCreateFiles', 'workspace/didCreateFiles')
  end,
})

vim.api.nvim_create_autocmd('User', {
  desc = 'Notify LSPs that a file was deleted',
  pattern = { 'MiniFilesActionDelete' },
  callback = function(args)
    local uri = vim.uri_from_fname(args.data.from)
    ---@type lsp.DeleteFilesParams
    local params = { files = { { uri = uri } } }
    wsFile(params, 'workspace/willDeleteFiles', 'workspace/didDeleteFiles')

    local bufnr = vim.uri_to_bufnr(uri)
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end,
})

local hipatterns = require('mini.hipatterns')
hipatterns.setup({
  highlighters = {
    hex_color = hipatterns.gen_highlighter.hex_color({}),
  },
})

require('mini.icons').setup({
  style = 'glyph',
})
MiniIcons.mock_nvim_web_devicons()
MiniIcons.tweak_lsp_kind()

require('mini.pairs').setup({})

require('mini.pick').setup({
  mappings = { choose_marked = '<C-q>' },
})
vim.keymap.set('n', '<Leader>sg', MiniPick.builtin.grep_live, { desc = 'Resume' })
vim.keymap.set('n', '<Leader>sr', MiniPick.builtin.resume, { desc = 'Resume' })
vim.keymap.set('n', '<Leader><Leader>', function()
  local scopes = {
    buf_lines = { 'current', 'all' },
    diagnostic = { 'current', 'all' },
    git_branches = { 'all', 'local', 'remotes' },
    git_files = { 'tracked', 'modified', 'untracked', 'ignored', 'deleted' },
    git_hunks = { 'unstaged', 'staged' },
    hipatterns = { 'current', 'all' },
    history = { 'cmd', 'search', 'expr', 'input', 'debug', 'all' },
    keymaps = { 'all', 'global', 'buf' },
    list = { 'quickfix', 'location', 'jump', 'change' },
    lsp = {
      'declaration',
      'definition',
      'document_symbol',
      'implementation',
      'references',
      'type_definition',
      'workspace_symbol',
    },
    marks = { 'all', 'global', 'buf' },
    options = { 'all', 'global', 'win', 'buf' },
  }
  local disabled = { 'cli', 'visit_paths', 'visit_labels' }
  ---@type {builtin: string, callback: any, scope: string?}[]
  local items = {}
  for key, value in vim.spairs(MiniPick.registry) do
    if vim.tbl_contains(disabled, key) then
      -- Do nothing
    elseif scopes[key] ~= nil then
      for _, scope in ipairs(scopes[key]) do
        items[#items + 1] = { builtin = key, callback = value, scope = scope }
      end
    else
      items[#items + 1] = { builtin = key, callback = value }
    end
  end
  vim.ui.select(items, {
    format_item = function(item)
      if item.scope then
        return ('%s (%s)'):format(item.builtin, item.scope)
      else
        return item.builtin
      end
    end,
    prompt = 'Pickers',
  }, function(item)
    if item then item.callback({ scope = item.scope }) end
  end)
end, { desc = 'Select picker' })

require('mini.splitjoin').setup({})

local gen_loader = require('mini.snippets').gen_loader
require('mini.snippets').setup({
  snippets = {
    gen_loader.from_runtime('global.json'),
    gen_loader.from_lang(),
  },
})
local function select_snippet() MiniSnippets.expand({ match = false }) end
vim.keymap.set('i', '<C-g><C-j>', select_snippet, { desc = 'Expand all' })
vim.keymap.set('n', '<Leader>ss', select_snippet, { desc = 'Snippets' })

vim.keymap.set('n', '<Esc>', function()
  while MiniSnippets.session.get() do
    MiniSnippets.session.stop()
  end
  vim.cmd('noh')
  return '<Esc>'
end, { desc = 'Escape', expr = true })

for _, value in ipairs({
  'MiniSnippetsCurrent',
  'MiniSnippetsCurrentReplace',
  'MiniSnippetsFinal',
  'MiniSnippetsUnvisited',
  'MiniSnippetsVisited',
}) do
  vim.cmd({
    cmd = 'highlight',
    args = { value, 'cterm=underdotted', 'gui=underdotted' },
  })
end

require('mini.surround').setup({
  mappings = {
    add = 'ys',
    delete = 'ds',
    find = '',
    find_left = '',
    highlight = '',
    replace = 'cs',
    update_n_lines = '',
    suffix_last = '',
    suffix_next = '',
  },
  n_lines = 100,
  search_method = 'cover',
})
vim.keymap.del('x', 'ys')
vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
vim.keymap.set('n', 'yss', 'ys_', { remap = true })
