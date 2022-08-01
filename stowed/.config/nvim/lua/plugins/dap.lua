local dap = require "dap"
local dapui = require "dapui"

-- UI
dapui.setup {
  icons = { expanded = "-", collapsed = "+" },
}
dap.listeners.after.event_initialized["dapui_config"] = dapui.open

vim.api.nvim_set_hl(0, "DapUIScope", { link = "Special" })
vim.api.nvim_set_hl(0, "DapUIType", { link = "TSType" })
vim.api.nvim_set_hl(0, "DapUIModifiedValue", { link = "Special", bold = true })
vim.api.nvim_set_hl(0, "DapUIDecoration", { link = "Special" })
vim.api.nvim_set_hl(0, "DapUIThread", { link = "TSTag" })
vim.api.nvim_set_hl(0, "DapUIStoppedThread", { link = "Special" })
vim.api.nvim_set_hl(0, "DapUISource", { link = "TSType" })
vim.api.nvim_set_hl(0, "DapUILineNumber", { link = "LineNr" })
vim.api.nvim_set_hl(0, "DapUIFloatBorder", { link = "Normal" })
vim.api.nvim_set_hl(0, "DapUIWatchesEmpty", { link = "Error" })
vim.api.nvim_set_hl(0, "DapUIWatchesValue", { link = "TSTag" })
vim.api.nvim_set_hl(0, "DapUIWatchesError", { link = "Error" })
vim.api.nvim_set_hl(0, "DapUIBreakpointsPath", { link = "Special" })
vim.api.nvim_set_hl(0, "DapUIBreakpointsInfo", { link = "TSTag" })
vim.api.nvim_set_hl(0, "DapUIBreakpointsCurrentLine", { link = "TSTag", bold = true })
vim.api.nvim_set_hl(0, "DapUIBreakpointsDisabledLine", { link = "Comment" })

-- Configurations
dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
  },
}
dap.adapters.nlua = function(callback, config)
  callback { type = "server", host = config.host or "127.0.0.1", port = config.port or 8088 }
end

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
vim.keymap.set("n", "<leader>dv", "<cmd>DapVirtualTextToggle<CR>", { desc = "Toggle virtual text" })

vim.keymap.set("n", "<leader>de", dapui.eval, { desc = "Eval" })
vim.keymap.set("v", "<leader>de", dapui.eval, { desc = "Eval" })
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle UI" })
