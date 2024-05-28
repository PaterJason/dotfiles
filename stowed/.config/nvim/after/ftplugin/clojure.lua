vim.g.clojure_fuzzy_indent_patterns = { "^with", "^def", "^let", "^comment$" }
vim.g.clojure_maxlines = 0
vim.g.clojure_align_subforms = 1

if true then
  require("nrepl").init()

  local action = require("nrepl.action")
  vim.keymap.set("n", "<LocalLeader>nf", action.load_file, { desc = "Load file" })
  vim.keymap.set("n", "<LocalLeader>ne", action.eval_cursor, { desc = "Eval cursor symbol" })
  vim.keymap.set("n", "<LocalLeader>np", action.eval_input, { desc = "Eval input" })
  vim.keymap.set("n", "<LocalLeader>ni", action.interrupt, { desc = "Interrupt" })
  vim.keymap.set("n", "<LocalLeader>nK", action.lookup_hover, { desc = "Hover lookup" })
  vim.keymap.set("n", "<LocalLeader>nl", "<Cmd>vsplit | Nrepl log<CR>", { desc = "Hover lookup" })
end
