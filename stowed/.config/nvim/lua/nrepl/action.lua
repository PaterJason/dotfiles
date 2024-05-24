local tcp = require("nrepl.tcp")
local state = require("nrepl.state")

M = {}

---@param host string?
---@param port string?
function M.connect(host, port)
  host = host or "localhost"
  if port == nil then
    for line in io.lines(".nrepl-port") do
      if line then
        port = line
        break
      end
    end
  end

  local client = tcp.connect(host, tonumber(port))
  if client then state.client = client end
end

function M.eval_buf()
  local text = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  local file = vim.fn.expand("%:p")

  tcp.write(state.client, {
    op = "eval",
    code = table.concat(text, "\n"),
    session = state.session,

    file = file,
  })
end

function M.eval_input()
  vim.ui.input(
    { prompt = "=> " },
    function(input)
      tcp.write(state.client, {
        op = "eval",
        code = input,
        session = state.session,
      })
    end
  )
end

function M.eval_tsnode()
  local node = vim.treesitter.get_node()
  if node == nil then
    vim.notify("No  TS node", vim.log.levels.WARN)
    return
  end
  local text = vim.treesitter.get_node_text(node, 0)
  local row, col = node:range()
  local file = vim.fn.expand("%:p")

  tcp.write(state.client, {
    op = "eval",
    code = text,
    session = state.session,

    file = file,
    line = row,
    column = col,
  })
end

function M.log()
  local buf = require("nrepl.util").get_log_buf()
  vim.cmd({ cmd = "buffer", args = { buf } })
end

return M
