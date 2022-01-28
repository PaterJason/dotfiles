require('which-key').register({
  ['r'] = { '<cmd>RustRunnables<CR>', 'Runnables' },
  ['d'] = { '<cmd>RustDebuggables<CR>', 'Debuggables' },
}, { prefix = '<localleader>', buffer = 0 })
