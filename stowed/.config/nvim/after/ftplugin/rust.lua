require('which-key').register({
  ['r'] = { '<cmd>RustRunnables<CR>', 'Runnables' },
  ['R'] = { '<cmd>RustDebuggables<CR>', 'Debuggables' },
}, { prefix = '<localleader>', buffer = 0 })
