local util = require("nrepl.util")
local config = require("nrepl.config")
local tcp = require("nrepl.tcp")
local state = require("nrepl.state")

M = {}

---@param host? string
---@param port? string
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

function M.close()
  local client = state.client
  if client then client:close() end
end

---@param session? string
function M.clone_session(session)
  tcp.write(state.client, {
    op = "clone",
    id = util.msg_id.session_modify,
    session = session,
  })
end

---@param session? string
function M.close_session(session)
  if session then
    tcp.write(state.client, {
      op = "close",
      id = util.msg_id.session_modify,
      session = session,
    })
  else
    util.select_session(M.close)
  end
end

---@param session? string
function M.set_session(session)
  if session then
    state.session = session
  else
    util.select_session(function(item)
      if item then state.session = item end
    end)
  end
end

function M.eval_input()
  vim.ui.input(
    { prompt = "=> " },
    function(input)
      tcp.write(state.client, {
        op = "eval",
        id = util.msg_id.eval_input,
        code = input,
        session = state.session,
      })
    end
  )
end

function M.eval_cursor()
  local node = util.get_ts_node("elem", { cursor = true, last = true })
  if node == nil then
    vim.notify("No  TS node", vim.log.levels.WARN)
    return
  end
  local text = vim.treesitter.get_node_text(node, 0)
  local row, col = node:range()
  local file = vim.fn.expand("%:p")

  tcp.write(state.client, {
    op = "eval",
    id = util.msg_id.eval_cursor,
    code = text,
    session = state.session,
    ns = util.get_ts_text("ns"),
    file = file,
    line = row,
    column = col,
  })
end

---@param session? string
function M.interrupt(session)
  session = session or state.session
  if session then tcp.write(state.client, {
    op = "interrupt",
    session = session,
  }) end
end

function M.load_file()
  local text = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  local file_path = vim.fn.expand("%:p")

  tcp.write(state.client, {
    op = "load-file",
    id = util.msg_id.load_file,
    session = state.session,
    file = table.concat(text, "\n"),
    ["file-path"] = file_path,
    ["file-name"] = vim.fs.basename(file_path),
  })
end

function M.lookup_definition()
  local sym = util.get_ts_text("sym", { cursor = true })
  if sym then
    tcp.write(state.client, {
      op = "lookup",
      id = util.msg_id.lookup_definition,
      sym = util.get_ts_text("sym", { cursor = true }),
      ns = util.get_ts_text("ns"),
    })
  else
    vim.notify("No valid symbol found at cursor position", vim.log.levels.WARN)
  end
end

function M.lookup_hover()
  local sym = util.get_ts_text("sym", { cursor = true })
  if sym then
    tcp.write(state.client, {
      op = "lookup",
      id = util.msg_id.lookup_hover,
      sym = util.get_ts_text("sym", { cursor = true }),
      ns = util.get_ts_text("ns"),
    })
  else
    vim.lsp.util.open_floating_preview(
      { "No valid symbol found at cursor position" },
      "",
      config.floating_preview
    )
  end
end

---@param session? string
function M.log(session)
  local buf = require("nrepl.util").get_log_buf(session)
  vim.cmd({ cmd = "buffer", args = { buf } })
end

return M
