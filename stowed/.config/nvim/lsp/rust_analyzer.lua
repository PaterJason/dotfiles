local function run_cargo(args)
  local cmd = { "cargo" }
  vim.list_extend(cmd, args.cargoArgs)
  table.insert(cmd, "--")
  vim.list_extend(cmd, args.executableArgs)
  local b = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(b, true, { split = "below" })
  vim.fn.jobstart(cmd, {
    cwd = args.cwd,
    term = true,
  })
end

local function debug_cargo(args)
  local cmd_args = {}
  vim.list_extend(cmd_args, args.cargoArgs)
  table.insert(cmd_args, "--")
  vim.list_extend(cmd_args, args.executableArgs)

  local dap = require("dap")
  dap.run({
    name = "rust-analyzer.debugSingle",
    type = "codelldb",
    request = "launch",
    program = "${cargo:program}",
    cargo = {
      args = cmd_args,
      cwd = args.cwd,
      problemMatcher = "$rustc",
    },
    sourceLanguages = { "rust" },
    stopOnEntry = false,
  })
end

---@type vim.lsp.Config
return {
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy",
        extraArgs = { "--", "-W", "clippy::pedantic" },
      },
      diagnostics = { warningsAsInfo = { "clippy::pedantic" } },
    },
  },
  commands = {
    ["rust-analyzer.runSingle"] = function(command, ctx)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if not client then return end
      vim.ui.select(command.arguments, {
        format_item = function(item) return item.label end,
        prompt = command.title,
      }, function(choice) run_cargo(choice.args) end)
    end,
    ["rust-analyzer.debugSingle"] = function(command, ctx)
      vim.print("rust-analyzer.runSingle", command, ctx)
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      if not client then return end
      vim.ui.select(command.arguments, {
        format_item = function(item) return item.label end,
        prompt = command.title,
      }, function(choice) debug_cargo(choice.args) end)
    end,
  },
}
