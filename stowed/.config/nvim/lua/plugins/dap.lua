local dap = require 'dap'
local widgets = require 'dap.ui.widgets'

require('nvim-dap-virtual-text').setup {
  highlight_new_as_changed = true,
}

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = 'Attach to running Neovim instance',
  },
}

dap.adapters.nlua = function(callback, config)
  callback { type = 'server', host = config.host or '127.0.0.1', port = config.port or 8088 }
end

local augroup = vim.api.nvim_create_augroup('Dap', {})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'dap-repl',
  callback = require('dap.ext.autocompl').attach,
  group = augroup,
})

require('which-key').register({
  name = 'DAP',
  b = { dap.toggle_breakpoint, 'Toggle Breakpoint' },
  c = { dap.continue, 'Continue' },
  C = { dap.run_to_cursor, 'Run To Cursor' },
  e = {
    function()
      widgets.hover(nil, { border = 'solid' })
    end,
    'Hover',
  },
  n = { dap.next, 'Next' },
  q = {
    function()
      dap.terminate()
      dap.close()
    end,
    'Quit',
  },
  r = { dap.repl.toggle, 'Toggle Repl' },
  v = { '<cmd>DapVirtualTextToggle<CR>', 'Quit' },
}, {
  prefix = '<leader>d',
})
