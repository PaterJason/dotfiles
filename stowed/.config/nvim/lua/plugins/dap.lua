---@type LazySpec
local M = {
  "mfussenegger/nvim-dap",
}

function M.config()
  local dap = require "dap"
  local widgets = require "dap.ui.widgets"
  dap.defaults.fallback.terminal_win_cmd = "tabnew"

  vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
  vim.keymap.set("n", "<Leader>dr", dap.repl.toggle, { desc = "Toggle repl" })
  vim.keymap.set({ "n", "v" }, "<Leader>dh", widgets.hover, { desc = "Hover" })
  vim.keymap.set("n", "<Leader>df", function()
    widgets.centered_float(widgets.frames)
  end, { desc = "Frames" })
  vim.keymap.set("n", "<Leader>ds", function()
    widgets.centered_float(widgets.scopes)
  end, { desc = "Scopes" })

  dap.adapters.firefox = {
    type = "executable",
    command = "firefox-debug-adapter",
  }
  dap.configurations.javascript = {
    {
      name = "Debug with Firefox",
      type = "firefox",
      request = "launch",
      reAttach = true,
      url = "http://localhost:3000",
      webRoot = "${workspaceFolder}",
    },
  }
  dap.configurations.typescript = dap.configurations.javascript

  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = "codelldb",
      args = { "--port", "${port}" },
    },
  }
  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.uv.cwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
  }
  dap.configurations.c = dap.configurations.cpp
  dap.configurations.rust = dap.configurations.cpp
end

return M
