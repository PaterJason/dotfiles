vim.g.clojure_fuzzy_indent_patterns = { "^with", "^def", "^let", "^comment$" }
vim.g.clojure_maxlines = 0
vim.g.clojure_align_subforms = 1

if true then
  require("nrepl").init()

  local action = require("nrepl.action")
  vim.keymap.set(
    { "n", "x" },
    "<LocalLeader>e",
    action.eval_operator,
    { desc = "Eval operator", buffer = 0, expr = true }
  )
  vim.keymap.set("n", "<LocalLeader>ee", action.eval_cursor, { desc = "Eval cursor", buffer = 0 })
  vim.keymap.set("n", "<LocalLeader>lf", action.load_file, { desc = "Load file", buffer = 0 })
  vim.keymap.set("n", "<LocalLeader>ll", "<Cmd>Nrepl log<CR>", { desc = "Log", buffer = 0 })
  vim.keymap.set("n", "<LocalLeader>ls", "<Cmd>split | Nrepl log<CR>", {
    desc = "Log split",
    buffer = 0,
  })
  vim.keymap.set(
    "n",
    "<LocalLeader>lv",
    "<Cmd>vsplit | Nrepl log<CR>",
    { desc = "Log vsplit", buffer = 0 }
  )
  vim.keymap.set(
    "n",
    "<LocalLeader>lt",
    "<Cmd>tabnew | Nrepl log<CR>",
    { desc = "Log split", buffer = 0 }
  )

  vim.keymap.set("n", "<LocalLeader>K", action.hover, { desc = "Hover lookup", buffer = 0 })
  vim.keymap.set("n", "<LocalLeader>np", action.eval_input, { desc = "Eval input", buffer = 0 })
  vim.keymap.set("n", "<LocalLeader>ni", action.interrupt, { desc = "Interrupt", buffer = 0 })
end
