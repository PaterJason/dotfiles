local dap = require 'dap'

dap.adapters.nlua = function(callback, config)
  callback { type = 'server', host = config.host, port = config.port }
end

vim.cmd 'au FileType dap-repl lua require("dap.ext.autocompl").attach()'

require('dap.ui.variables').multiline_variable_display = true
