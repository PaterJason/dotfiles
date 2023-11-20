vim.keymap.set("n", "<localleader>r", "<Cmd>RustLsp runnables<CR>", { buffer = 0, desc = "Runnables" })
vim.keymap.set("n", "<localleader>d", "<Cmd>RustLsp debuggables<CR>", { buffer = 0, desc = "Debuggables" })
