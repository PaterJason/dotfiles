vim.bo.keywordprg = ":help"

vim.keymap.set("n", "<localleader>r", '<cmd>lua require"osv".run_this()<CR>', { buffer = 0, desc = "Run this" })
