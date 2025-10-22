--- catppuccin integration adds hl groups
for name, text in pairs({
  DapBreakpoint = { ' ' },
  DapBreakpointCondition = { ' ' },
  DapBreakpointRejected = { ' ' },
  DapLogPoint = { ' ' },
  DapStopped = { ' ', 'debugPC' },
}) do
  vim.fn.sign_define(name, { text = text[1], texthl = name, linehl = text[2] })
end

local dap = require('dap')

local dap_view = require('dap-view')
--- @diagnostic disable-next-line: missing-fields, param-type-not-match
dap_view.setup({
  winbar = {
    show = true,
    sections = {
      'scopes',
      'threads',
      'breakpoints',
      'watches',
      'exceptions',
      'sessions',
      'repl',
      'console',
    },
    default_section = 'scopes',
    controls = { enabled = true },
  },
})

dap.listeners.before.attach['user'] = function() dap_view.open() end
dap.listeners.before.launch['user'] = function() dap_view.open() end

--- @diagnostic disable-next-line: missing-fields, param-type-not-match
require('nvim-dap-virtual-text').setup({
  highlight_new_as_changed = true,
  virt_text_pos = 'eol',
})
vim.cmd([[hi link NvimDapVirtualText LspInlayHint]])

vim.keymap.set('n', '<F5>', function() dap.continue() end, { desc = 'Continue' })
vim.keymap.set('n', '<F10>', function() dap.step_over() end, { desc = 'Step over' })
vim.keymap.set('n', '<F11>', function() dap.step_into() end, { desc = 'Step into' })
vim.keymap.set('n', '<F12>', function() dap.step_out() end, { desc = 'Step out' })
vim.keymap.set(
  'n',
  '<Leader>db',
  function() dap.toggle_breakpoint() end,
  { desc = 'Toggle breakpoint' }
)
vim.keymap.set(
  'n',
  '<Leader>dl',
  function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
  { desc = 'Set log point' }
)
vim.keymap.set(
  'n',
  '<Leader>dc',
  function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
  { desc = 'Set conditional breakpoint' }
)
vim.keymap.set('n', '<Leader>dv', '<Cmd>DapViewToggle<CR>', { desc = 'Toggle View' })
vim.keymap.set({ 'n', 'v' }, '<Leader>dw', ':DapViewWatch<CR>', { desc = 'Watch' })
vim.keymap.set('n', '<Leader>dr', function() dap.run_to_cursor() end, { desc = 'Run to cursor' })
vim.keymap.set(
  { 'n', 'v' },
  '<Leader>dh',
  function() require('dap.ui.widgets').hover() end,
  { desc = 'Hover' }
)

-- JavaScript & TypeScript
-- gh release download --pattern 'js-debug-dap-*.gz' --repo 'microsoft/vscode-js-debug' -O - | tar -xzvf -
dap.adapters['pwa-node'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'node',
    args = { vim.fs.abspath('~/src/dap/js-debug/src/dapDebugServer.js'), '${port}' },
  },
}
dap.adapters['pwa-chrome'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'node',
    args = { vim.fs.abspath('~/src/dap/js-debug/src/dapDebugServer.js'), '${port}' },
  },
}
dap.configurations.javascript = {
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    cwd = '${workspaceFolder}',
  },
  {
    type = 'pwa-chrome',
    request = 'launch',
    name = 'Launch Chromium',
    webRoot = '${workspaceFolder}',
    runtimeExecutable = '/usr/bin/chromium',
  },
}
dap.configurations.javascriptreact = dap.configurations.javascript
dap.configurations.typescript = dap.configurations.javascript
dap.configurations.typescriptreact = dap.configurations.javascript

-- LLDB
dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-dap',
  name = 'lldb',
}
dap.configurations.rust = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      local metadata =
        vim.system({ 'cargo', 'metadata', '--format-version', '1' }):wait(10000).stdout
      if metadata == nil then
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end
      return require('dap.utils').pick_file({
        path = vim.fs.joinpath(
          vim.tbl_get(vim.json.decode(metadata, {}), 'target_directory'),
          'debug'
        ),
      })
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    initCommands = function()
      local sysobj = vim.system({ 'rustc', '--print', 'sysroot' }):wait(4000)
      assert(
        sysobj.stdout ~= nil,
        'failed to get rust sysroot using `rustc --print sysroot`: ' .. (sysobj.stderr or '')
      )
      local rustc_sysroot = vim.trim(sysobj.stdout)
      local script_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py'
      local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'
      return {
        ([[!command script import '%s']]):format(script_file),
        ([[command source '%s']]):format(commands_file),
      }
    end,
  },
}
dap.configurations.c = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}
dap.configurations.cpp = dap.configurations.c

-- Go
dap.adapters.delve = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'dlv',
    args = { 'dap', '-l', 'localhost:${port}' },
  },
}
dap.configurations.go = {
  {
    type = 'delve',
    name = 'Debug',
    request = 'launch',
    program = '${file}',
  },
  {
    type = 'delve',
    name = 'Debug test',
    request = 'launch',
    mode = 'test',
    program = '${file}',
  },
  {
    type = 'delve',
    name = 'Debug test (go.mod)',
    request = 'launch',
    mode = 'test',
    program = './${relativeFileDirname}',
  },
}

-- Godot GDScript
dap.adapters.godot = {
  type = 'server',
  host = '127.0.0.1',
  port = 6006,
}
dap.configurations.gdscript = {
  {
    type = 'godot',
    request = 'launch',
    name = 'Launch scene',
    project = '${workspaceFolder}',
  },
  {
    type = 'godot',
    request = 'attach',
    name = 'Attach to scene',
    project = '${workspaceFolder}',
  },
}
