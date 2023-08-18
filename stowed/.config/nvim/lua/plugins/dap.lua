local function config()
  local dap = require "dap"
  local dapui = require "dapui"

  -- UI
  dapui.setup {
    icons = { expanded = "-", collapsed = "+" },
  }
  dap.listeners.after.event_initialized["dapui_config"] = dapui.open
  dap.listeners.before.event_terminated["dapui_config"] = dapui.close
  dap.listeners.before.event_exited["dapui_config"] = dapui.close

  dap.adapters.firefox = {
    type = "executable",
    command = "firefox-debug-adapter",
  }
  dap.configurations.javascript = {
    {
      name = "Debug with Firefox (Javascript)",
      type = "firefox",
      request = "launch",
      reAttach = true,
      url = "http://localhost:3000",
      webRoot = "${workspaceFolder}",
    },
  }
  dap.configurations.typescript = {
    {
      name = "Debug with Firefox (Typescript)",
      type = "firefox",
      request = "launch",
      reAttach = true,
      url = "http://localhost:3000",
      webRoot = "${workspaceFolder}",
    },
  }

  -- Mappings
  vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
  vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
  vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to cursor" })
  vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "Next" })
  vim.keymap.set("n", "<leader>dq", function()
    dap.terminate()
    dap.close()
  end, { desc = "Quit" })
  vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle Repl" })

  vim.keymap.set("n", "<leader>de", dapui.eval, { desc = "Eval" })
  vim.keymap.set("v", "<leader>de", dapui.eval, { desc = "Eval" })
  vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle UI" })
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
    },
    config = config,
  },
}
