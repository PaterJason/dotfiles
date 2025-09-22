-- nrepl plugin
require('nrepl').init()

local action = require('nrepl.action')
vim.keymap.set(
  { 'n', 'x' },
  '<LocalLeader>e',
  '<Plug>(NreplEvalOperator)',
  { desc = 'Eval', buffer = 0 }
)
vim.keymap.set('n', 'g==', action.eval_cursor, { desc = 'Eval cursor', buffer = 0 })
vim.keymap.set('n', '<LocalLeader>lf', action.load_file, { desc = 'Load file', buffer = 0 })
vim.keymap.set('n', '<LocalLeader>ll', '<Cmd>Nrepl log<CR>', { desc = 'Log', buffer = 0 })
vim.keymap.set(
  'n',
  '<LocalLeader>ls',
  function()
    require('nrepl.prompt').open_win(true, {
      win = -1,
      vertical = false,
    })
  end,
  {
    desc = 'Log split',
    buffer = 0,
  }
)
vim.keymap.set(
  'n',
  '<LocalLeader>lv',
  function()
    require('nrepl.prompt').open_win(true, {
      win = -1,
      vertical = true,
    })
  end,
  { desc = 'Log vsplit', buffer = 0 }
)
vim.keymap.set(
  'n',
  '<LocalLeader>lt',
  '<Cmd>tabnew | Nrepl log<CR>',
  { desc = 'Log split', buffer = 0 }
)

vim.keymap.set('n', '<LocalLeader>K', action.hover, { desc = 'Hover lookup', buffer = 0 })
vim.keymap.set('n', '<LocalLeader>np', action.eval_input, { desc = 'Eval input', buffer = 0 })
vim.keymap.set('n', '<LocalLeader>ni', action.interrupt, { desc = 'Interrupt', buffer = 0 })
