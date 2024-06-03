local util = require("nrepl.util")
local tcp = require("nrepl.tcp")
local state = require("nrepl.state")

M = {}

---@param host? string
---@param port? string
function M.connect(host, port)
  host = host or "localhost"
  if port == nil then
    local port_file = ".nrepl-port"
    if not vim.uv.fs_stat(port_file) then return end
    for line in io.lines(port_file) do
      if line then
        port = line
        break
      end
    end
  end

  local client = tcp.connect(host, tonumber(port))
  if client then state.data.client = client end
end

function M.disconnect()
  local client = state.data.client
  if client then
    client:close(function()
      vim.notify("nREPL client disconnected")
      state.reset()
    end)
  end
end

---@param session? string
function M.session_clone(session)
  tcp.write(state.data.client, {
    op = "clone",
    id = util.msg_id.session_modify,
    session = session,
  })
end

---@param session? string
function M.session_close(session)
  if session then
    tcp.write(state.data.client, {
      op = "close",
      id = util.msg_id.session_modify,
      session = session,
    })
  else
    util.select_session(M.session_close)
  end
end

---@param session? string
function M.session_select(session)
  if session then
    state.data.session = session
  else
    util.select_session(function(item)
      if item then state.data.session = item end
    end)
  end
end

function M.eval_input()
  vim.ui.input(
    {
      prompt = "=> ",
      completion = "customlist,v:lua.require'nrepl.completion'.command",
    },
    function(input)
      tcp.write(state.data.client, {
        op = "eval",
        id = util.msg_id.eval_input,
        code = input,
      })
    end
  )
end

function M.eval_cursor()
  local node = util.get_ts_node("elem", { cursor = true, last = true })
  if node == nil then
    vim.notify("No TS node", vim.log.levels.WARN)
    return
  end
  local text = vim.treesitter.get_node_text(node, 0)
  local row, col = node:start()
  local file = vim.fn.expand("%:p")

  tcp.write(state.data.client, {
    op = "eval",
    id = util.msg_id.eval_cursor,
    code = text,
    ns = util.get_ts_text("ns"),
    file = file,
    line = row + 1,
    column = col + 1,
  })
end

---@param session? string
function M.interrupt(session)
  tcp.write(state.data.client, {
    op = "interrupt",
    session = session,
  })
end

function M.load_file()
  local text = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  local file_path = vim.fn.expand("%:p")

  tcp.write(state.data.client, {
    op = "load-file",
    id = util.msg_id.load_file,
    file = table.concat(text, "\n"),
    ["file-path"] = file_path,
    ["file-name"] = vim.fs.basename(file_path),
  })
end

function M.definition()
  local sym = util.get_ts_text("sym", { cursor = true })
  if sym then
    tcp.write(state.data.client, {
      op = "lookup",
      id = util.msg_id.lookup_definition,
      sym = sym,
      ns = util.get_ts_text("ns"),
    })
  else
    vim.notify("No valid symbol found at cursor position", vim.log.levels.WARN)
  end
end

function M.hover()
  local sym = util.get_ts_text("sym", { cursor = true })
  if not sym then
    util.open_floating_preview({ "No valid symbol found at cursor position" })
  elseif state.data.server.ops["info"] then
    tcp.write(state.data.client, {
      op = "info",
      id = util.msg_id.cider_info_hover,
      sym = sym,
      ns = util.get_ts_text("ns"),
    })
  else
    tcp.write(state.data.client, {
      op = "lookup",
      id = util.msg_id.lookup_hover,
      sym = sym,
      ns = util.get_ts_text("ns"),
    })
  end
end

---@param session? string
function M.log(session)
  local buf = require("nrepl.util").get_log_buf(session)
  if buf then
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(buf), 0 })
  end
end

return M
