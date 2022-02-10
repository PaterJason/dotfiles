local dap = require 'dap'

require('nvim-dap-virtual-text').setup {
  highlight_new_as_changed = true,
}

dap.adapters.nlua = function(callback, config)
  callback { type = 'server', host = config.host, port = config.port }
end

vim.cmd 'au FileType dap-repl lua require("dap.ext.autocompl").attach()'

function _G.dap_keymap()
  local wk = require 'which-key'
  wk.register({
    name = 'DAP',
    b = { "<cmd>lua require'dap'.toggle_breakpoint()<CR>", 'Toggle Breakpoint' },
    c = { "<cmd>lua require'dap'.continue()<CR>", 'Continue' },
    C = { "<cmd>lua require'dap'.run_to_cursor()<CR>", 'Run To Cursor' },
    d = { "<cmd>lua require'dap'.disconnect()<CR>", 'Disconnect' },
    e = { "<cmd>lua require'dap.ui.widgets'.hover(nil, {border = 'solid'})<CR>", 'Hover' },
    q = { "<cmd>lua require'dap'.terminate()<CR>", 'Quit' },
    r = { "<cmd>lua require'dap'.repl.toggle()<CR>", 'Toggle Repl' },
    v = { '<cmd>DapVirtualTextToggle<CR>', 'Quit' },
  }, {
    prefix = '<leader>d',
    buffer = 0,
  })
end

local autocmds = { 'augroup dap_keymap', 'autocmd!' }
for _, ft in ipairs { 'dap-repl', 'lua', 'rust' } do
  vim.list_extend(autocmds, { 'autocmd FileType ' .. ft .. ' call v:lua.dap_keymap()' })
end
vim.list_extend(autocmds, { 'augroup END' })
vim.cmd(table.concat(autocmds, '\n'))
