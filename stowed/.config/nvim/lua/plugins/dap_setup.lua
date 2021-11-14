function _G.dap_keymap()
  local wk = require 'which-key'
  wk.register({
    e = { '<cmd>lua require"dap.ui.variables".hover()<CR>', 'Hover' },
    s = { '<cmd>lua require"dap.ui.variables".scopes()<CR>', 'Scopes' },
    b = { '<cmd>lua require"dap".toggle_breakpoint()<CR>', 'Toggle breakpoint' },
    B = {
      '<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
      'Conditional breakpoint',
    },
    l = {
      name = 'REPL',
      s = { '<cmd>lua require"dap".repl.open({},  "belowright split")<CR>', 'Horizontal' },
      v = { '<cmd>lua require"dap".repl.open({},  "belowright vsplit")<CR>', 'Vertical' },
      q = { '<cmd>lua require"dap".repl.close()<CR>', 'Close' },
    },
    q = { '<cmd>lua require"dap".disconnect({ terminateDebuggee = true });require"dap".close()<CR>', 'Disconnect' },
    c = { '<cmd>lua require"dap".continue()<CR>', 'Continue' },
    n = { '<cmd>lua require"dap".step_over()<CR>', 'Step over' },
    i = { '<cmd>lua require"dap".step_into()<CR>', 'Step into' },
    I = { '<cmd>lua require"dap".step_into()<CR>', 'Step into target' },
    o = { '<cmd>lua require"dap".step_out()<CR>', 'Step out' },
    u = { '<cmd>lua require"dap".up()<CR>', 'Up' },
    d = { '<cmd>lua require"dap".down()<CR>', 'Down' },
  }, {
    prefix = '<localleader>',
    buffer = 0,
  })
  wk.register({
    e = { ':lua require"dap.ui.variables".visual_hover()<CR>', 'Hover' },
  }, {
    prefix = '<localleader>',
    mode = 'v',
    buffer = 0,
  })
  wk.register({
    name = 'DAP',
    f = { '<cmd>Telescope dap frames<CR>', 'Frames' },
    b = { '<cmd>Telescope dap list_breakpoints<CR>', 'Breakpoints' },
    [':'] = { '<cmd>Telescope dap commands<CR>', 'Commands' },
    v = { '<cmd>Telescope dap variables<CR>', 'Variables' },
    c = { '<cmd>Telescope dap configurations<CR>', 'Configurations' },
  }, {
    prefix = '<leader>fd',
    buffer = 0,
  })
end

local autocmds = { 'augroup dap_keymap', 'autocmd!' }
for _, ft in ipairs { 'dap-repl', 'lua', 'haskell' } do
  vim.list_extend(autocmds, { 'autocmd FileType ' .. ft .. ' call v:lua.dap_keymap()' })
end
vim.list_extend(autocmds, { 'augroup END' })
vim.cmd(table.concat(autocmds, '\n'))
