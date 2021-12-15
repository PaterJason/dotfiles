local dap = require 'dap'

dap.adapters.nlua = function(callback, config)
  callback { type = 'server', host = config.host, port = config.port }
end

vim.cmd 'au FileType dap-repl lua require("dap.ext.autocompl").attach()'

function _G.dap_keymap()
  local wk = require 'which-key'
  wk.register({
    name = 'DAP',
    t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", 'Toggle Breakpoint' },
    b = { "<cmd>lua require'dap'.step_back()<cr>", 'Step Back' },
    c = { "<cmd>lua require'dap'.continue()<cr>", 'Continue' },
    C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", 'Run To Cursor' },
    d = { "<cmd>lua require'dap'.disconnect()<cr>", 'Disconnect' },
    g = { "<cmd>lua require'dap'.session()<cr>", 'Get Session' },
    i = { "<cmd>lua require'dap'.step_into()<cr>", 'Step Into' },
    o = { "<cmd>lua require'dap'.step_over()<cr>", 'Step Over' },
    u = { "<cmd>lua require'dap'.step_out()<cr>", 'Step Out' },
    p = { "<cmd>lua require'dap'.pause.toggle()<cr>", 'Pause' },
    r = { "<cmd>lua require'dap'.repl.toggle()<cr>", 'Toggle Repl' },
    q = { "<cmd>lua require'dap'.close()<cr>", 'Quit' },
    s = {
      name = 'Telescope search',
      f = { '<cmd>Telescope dap frames<cr>', 'Frames' },
      c = { '<cmd>Telescope dap commands<cr>', 'Commands' },
      v = { '<cmd>Telescope dap variables<cr>', 'Variables' },
      C = { '<cmd>Telescope dap configurations<cr>', 'Configurations' },
      b = { '<cmd>Telescope dap list_breakpoints<cr>', 'List breakpoints' },
    },
  }, {
    prefix = '<leader>d',
    buffer = 0,
  })
  wk.register({
    K = { '<cmd>lua require"dapui".eval()<CR>', 'Hover' },
  }, {
    prefix = '<localleader>',
    buffer = 0,
    mode = 'v',
  })
end

local autocmds = { 'augroup dap_keymap', 'autocmd!' }
for _, ft in ipairs { 'dap-repl', 'lua', 'rust' } do
  vim.list_extend(autocmds, { 'autocmd FileType ' .. ft .. ' call v:lua.dap_keymap()' })
end
vim.list_extend(autocmds, { 'augroup END' })
vim.cmd(table.concat(autocmds, '\n'))
