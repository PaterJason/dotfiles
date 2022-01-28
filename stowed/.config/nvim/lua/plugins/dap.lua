local dap = require 'dap'
local widgets = require 'dap.ui.widgets'

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
    r = { "<cmd>lua require'dap'.repl.toggle()<CR>", 'Toggle Repl' },
    q = { "<cmd>lua require'dap'.close()<CR>", 'Quit' },
  }, {
    prefix = '<leader>d',
    buffer = 0,
  })
end

local sidebar_scopes = widgets.sidebar(widgets.scopes)
local sidebar_frames = widgets.sidebar(widgets.frames)
_G.dap_scopes = sidebar_scopes
_G.dap_frames = sidebar_frames

local autocmds = { 'augroup dap_keymap', 'autocmd!' }
for _, ft in ipairs { 'dap-repl', 'lua', 'rust' } do
  vim.list_extend(autocmds, { 'autocmd FileType ' .. ft .. ' call v:lua.dap_keymap()' })
end
vim.list_extend(autocmds, { 'augroup END' })
vim.cmd(table.concat(autocmds, '\n'))
