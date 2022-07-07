local dap = require "dap"
local widgets = require "dap.ui.widgets"

require("nvim-dap-virtual-text").setup {
  highlight_new_as_changed = true,
}

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

local augroup = vim.api.nvim_create_augroup("Dap", {})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dap-repl",
  callback = require("dap.ext.autocompl").attach,
  group = augroup,
})

vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to cursor" })
vim.keymap.set("n", "<leader>de", function()
  widgets.hover()
end, { desc = "Hover" })
vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "Next" })
vim.keymap.set("n", "<leader>dq", function()
  dap.terminate()
  dap.close()
end, { desc = "Quit" })
vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle Repl" })
vim.keymap.set("n", "<leader>dv", "<cmd>DapVirtualTextToggle<CR>", { desc = "Toggle virtual text" })
