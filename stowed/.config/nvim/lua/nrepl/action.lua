local prompt = require("nrepl.prompt")
local state = require("nrepl.state")
local tcp = require("nrepl.tcp")
local util = require("nrepl.util")

local message = tcp.message

local M = {}

---@param host? string
---@param port? string
function M.connect(host, port)
  host = host or "localhost"
  if port == nil then
    local port_file = ".nrepl-port"
    if not vim.uv.fs_stat(port_file) then
      vim.notify("No .nrepl-port file")
      return
    end
    for line in io.lines(port_file) do
      if line then
        port = line
        break
      end
    end
  end
  local portnum = tonumber(port)

  local client = state.data.client
  if client then
    if client:is_closing() then
      state.reset()

      state.data.client = tcp.connect(host, portnum)
    else
      client:read_stop()
      client:shutdown()
      client:close(function()
        vim.notify("Existing nREPL client disconnected")
        state.reset()

        state.data.client = tcp.connect(host, portnum)
      end)
    end
  else
    state.data.client = tcp.connect(host, portnum)
  end
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
function M.session_select(session)
  if session then
    state.data.session = session
  else
    util.select_session(function(item)
      if item then state.data.session = item end
    end)
  end
end

---@param session? string
function M.session_clone(session) message.clone(session) end

---@param session? string
function M.session_close(session)
  if session then
    message.close(session)
  else
    util.select_session(M.session_close)
  end
end

---@param session? string
function M.log(session)
  local buf = prompt.get_buf(session)
  if buf then
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(buf), 0 })
  end
end

function M.eval_cursor()
  local pos = vim.api.nvim_win_get_cursor(0)
  pos[1] = pos[1] - 1

  local node = util.get_ts_node("elem", {
    start = pos,
    last = true,
  })
  if node == nil then
    util.open_floating_preview({ "No element found at position" })
    return
  end
  local start = { node:start() }
  local end_ = { node:end_() }

  message.eval_range(start, end_)
end

function M.eval_operator(motion_type)
  if motion_type then
    local start, end_ = util.get_operator_range(motion_type)
    message.eval_range(start, end_)
  else
    vim.go.operatorfunc = "v:lua.require'nrepl.action'.eval_operator"
    return "g@"
  end
end

function M.eval_input()
  vim.ui.input({
    prompt = "=> ",
    -- completion = "customlist,v:lua.require'nrepl'.command_completion_customlist",
  }, function(input) message.eval_text(input) end)
end

function M.load_file()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  local file_path = vim.fn.expand("%:p")

  message.load_file(file_path, lines)
end

---@param session? string
function M.interrupt(session) message.interrupt(session) end

function M.hover()
  local pos = vim.api.nvim_win_get_cursor(0)
  pos[1] = pos[1] - 1
  local ns = util.get_ts_text("ns")
  local sym = util.get_ts_text("sym", { start = pos })
  if not sym then
    util.open_floating_preview({ "No symbol found at cursor position" })
  elseif state.data.server.ops["info"] then
    message.info_hover(ns, sym)
  else
    message.lookup_hover(ns, sym)
  end
end

function M.definition()
  local pos = vim.api.nvim_win_get_cursor(0)
  pos[1] = pos[1] - 1
  local ns = util.get_ts_text("ns")
  local sym = util.get_ts_text("sym", { start = pos })

  message.lookup_definition(ns, sym)
end

return M
