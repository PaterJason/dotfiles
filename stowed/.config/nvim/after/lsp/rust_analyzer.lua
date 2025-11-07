local function run_cargo(args)
  local cmd = { 'cargo' }
  vim.list_extend(cmd, args.cargoArgs)
  table.insert(cmd, '--')
  vim.list_extend(cmd, args.executableArgs)
  local b = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(b, true, { split = 'below' })
  vim.fn.jobstart(cmd, {
    cwd = args.cwd,
    term = true,
  })
end

local function debug_cargo(args)
  local cmd_args = {}
  vim.list_extend(cmd_args, args.cargoArgs)
  table.insert(cmd_args, '--')
  vim.list_extend(cmd_args, args.executableArgs)

  local dap = require('dap')
  dap.run({
    name = 'rust-analyzer.debugSingle',
    type = 'rust_gdb',
    request = 'launch',
    program = 'cargo',
    args = cmd_args,
  })
end

---@type vim.lsp.Config
return {
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = 'clippy',
        extraArgs = { '--', '-W', 'clippy::pedantic' },
      },
      diagnostics = { warningsAsInfo = { 'clippy::pedantic' } },
    },
  },
  commands = {
    ['rust-analyzer.debugSingle'] = function(command, ctx)
      vim.print('rust-analyzer.runSingle', command, ctx)
    end,
  },
}
