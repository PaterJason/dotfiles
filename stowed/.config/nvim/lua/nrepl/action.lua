local util = require("nrepl.util")
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

---@param session string?
function M.clone(session)
  tcp.write(state.client, {
    op = "clone",
    session = session,
    id = util.msg_id.session_modify,
  })
end

---@param session string
function M.close(session)
  if session then
    tcp.write(state.client, {
      op = "close",
      session = session,
      id = util.msg_id.session_modify,
    })
  else
    vim.ui.select(state.server.sessions, {
      prompt = "Select session",
      format_item = function(item)
        local current_session = state.session
        if item == current_session then
          return item .. " (current)"
        else
          return item
        end
      end,
    }, function(item)
      if item then M.close(item) end
    end)
  end
end

---@param session string
function M.set_session(session)
  if session == nil then
    vim.ui.select(state.server.sessions, {
      prompt = "Select session",
      format_item = function(item)
        local current_session = state.session
        if item == current_session then
          return item .. " (current)"
        else
          return item
        end
      end,
    }, function(item)
      if item then state.session = item end
    end)
  else
    state.session = session
  end
end

function M.eval_input()
  vim.ui.input(
    { prompt = "=> " },
    function(input)
      tcp.write(state.client, {
        op = "eval",
        code = input,
        session = state.session,
        id = "eval_input",
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
    id = "eval_tsnode",
    file = file,
    line = row,
    column = col,
  })
end

function M.load_file()
  local text = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  local file_path = vim.fn.expand("%:p")

  tcp.write(state.client, {
    op = "load-file",
    id = "load_file",
    session = state.session,
    file = table.concat(text, "\n"),
    ["file-path"] = file_path,
    ["file-name"] = vim.fs.basename(file_path),
  })
end

---@param sym string
function M.lookup(sym)
  if sym then
    tcp.write(state.client, {
      op = "lookup",
      id = util.msg_id.lookup_hover,
      sym = sym,
    })
  else
    vim.ui.input({
      prompt = "Symbol: ",
    }, function(input)
      if input then vim.lookup(input) end
    end)
  end
end

---@param session? string
function M.log(session)
  local buf = require("nrepl.util").get_log_buf(session)
  vim.cmd({ cmd = "buffer", args = { buf } })
end

return M
