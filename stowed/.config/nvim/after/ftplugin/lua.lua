vim.bo.keywordprg = ':help'

require('which-key').register(
  { ['r'] = { '<cmd>lua require"osv".run_this()<CR>', 'Run this' } },
  { prefix = '<localleader>', buffer = 0 }
)
