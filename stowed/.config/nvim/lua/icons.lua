local M = {}

M.diagnostic = {
  [vim.diagnostic.severity.ERROR] = ' ',
  [vim.diagnostic.severity.WARN] = ' ',
  [vim.diagnostic.severity.INFO] = ' ',
  [vim.diagnostic.severity.HINT] = ' ',
}

M.diagnostic_hl = {
  [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
  [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
  [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
  [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
}

M.arrow = {
  right = ' ',
  left = ' ',
  up = ' ',
  down = ' ',
}

M.chevron = {
  right = ' ',
  left = ' ',
  up = ' ',
  down = ' ',
}

return M
