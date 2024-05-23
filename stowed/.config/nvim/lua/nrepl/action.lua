local client = require("nrepl.client")

M = {}

function M.eval_node()
  local node = vim.treesitter.get_node()
  if node == nil then
    vim.notify("No  TS node", vim.log.levels.WARN)
    return
  end
  local text = vim.treesitter.get_node_text(node, 0)
  local row, col = node:range()
  local file = vim.fn.expand("%:p")

  client.write(CLIENT, {
    op = "eval",
    code = text,
    session = STATE.sessions[1],

    file = file,
    line = row,
    column = col,
  })
end

return M
