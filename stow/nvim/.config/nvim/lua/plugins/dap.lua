local dap = require 'dap'

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = 'Attach to running Neovim instance',
    host = function()
      local value = vim.fn.input 'Host [127.0.0.1]: '
      if value ~= '' then
        return value
      end
      return '127.0.0.1'
    end,
    port = function()
      local value = tonumber(vim.fn.input 'Port [8088]: ')
      if value ~= nil then
        return value
      end
      return 8088
    end,
  },
}

dap.adapters.nlua = function(callback, config)
  callback { type = 'server', host = config.host, port = config.port }
end

vim.cmd 'au FileType dap-repl lua require("dap.ext.autocompl").attach()'

require('dapui').setup {}
