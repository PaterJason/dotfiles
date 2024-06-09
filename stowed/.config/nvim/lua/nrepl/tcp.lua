local bencode = require("nrepl.bencode")
local util = require("nrepl.util")
local state = require("nrepl.state")
local config = require("nrepl.config")

local M = {}

---@param message Nrepl.Message
---@param ... unknown
function M.write(message, ...)
  local client = state.data.client
  if not client then
    vim.notify("No nREPL client connected", vim.log.levels.WARN)
    return
  elseif not client:is_writable() then
    vim.notify("Cannot write to nREPL server", vim.log.levels.WARN)
    return
  end

  local request = message.make_request(...)
  if not request then return end
  request = vim.tbl_extend("keep", request, config.middleware_params, {
    id = "nvim:" .. state.data.msg_count,
    session = state.data.session,
  })
  state.data.msg_count = state.data.msg_count + 1

  if config.debug then vim.schedule(function() util.echo("DEBUG WRITE CALLBACK", request) end) end

  local transport = bencode.encode(request)
  if not transport then return end
  client:write(transport, function(err)
    assert(not err, err)
    if request.id then
      state.data.msgs[request.id] = {
        request = request,
        data = {},
        callback = message.callback,
      }
    end
  end)
end

---@alias Nrepl.Message.Callback fun(data: table, request: table)

---@class Nrepl.Message
---@field make_request fun(...: any):table?
---@field callback Nrepl.Message.Callback
---@overload fun(...: any)

---@type table<string, Nrepl.Message>
M.message = {
  describe = {
    make_request = function()
      return {
        op = "describe",
        ["verbose?"] = 1,
      }
    end,
    callback = function(response, _)
      if response.ops then state.data.server.ops = response.ops end
    end,
  },
  session_refresh = {
    make_request = function()
      return {
        op = "ls-sessions",
      }
    end,
    callback = function(response, _)
      if response.sessions then
        state.data.server.sessions = response.sessions
        if not vim.list_contains(response.sessions, state.data.session) then
          state.data.session = response.sessions[1]
        end
      end
    end,
  },
  clone = {
    make_request = function(session)
      return {
        op = "clone",
        session = session or vim.NIL,
      }
    end,
    callback = function(response, request)
      M.message.session_refresh()
      util.callback.status(response, request)
    end,
  },
  close = {
    make_request = function(session)
      return {
        op = "close",
        session = session,
      }
    end,
    callback = function(response, request)
      M.message.session_refresh()
      util.callback.status(response, request)
    end,
  },

  eval_range = {
    ---@param start [integer, integer]
    ---@param end_ [integer, integer]
    make_request = function(start, end_)
      local lines = vim.api.nvim_buf_get_text(0, start[1], start[2], end_[1], end_[2], {})
      local text = table.concat(lines, "\n")
      local file = vim.fn.expand("%:p")

      return {
        op = "eval",
        code = text,
        ns = util.get_ts_text("ns"),
        file = file,
        line = start[1] + 1,
        column = start[2] + 1,
      }
    end,
    callback = function(response, request) util.callback.eval(response, request) end,
  },
  eval_text = {
    make_request = function(text)
      if text == "" then return end
      return {
        op = "eval",
        code = text,
      }
    end,
    callback = function(response, request) util.callback.eval(response, request) end,
  },
  load_file = {
    make_request = function(file_path, lines)
      return {
        op = "load-file",
        file = table.concat(lines, "\n"),
        ["file-path"] = file_path,
        ["file-name"] = vim.fs.basename(file_path),
      }
    end,
    callback = function(response, request) util.callback.eval(response, request) end,
  },
  interrupt = {
    make_request = function(session)
      return {
        op = "interrupt",
        session = session,
      }
    end,
    callback = util.callback.status,
  },

  lookup_definition = {
    make_request = function(ns, sym)
      return {
        op = "lookup",
        sym = sym,
        ns = ns,
      }
    end,
    callback = function(response, _)
      if response.info and not vim.tbl_isempty(response.info) then
        local file = response.info.file
        local line = response.info.line
        local column = response.info.column

        if file and line and column then
          vim.cmd({ cmd = "edit", args = { util.file_str(file) } })
          vim.api.nvim_win_set_cursor(0, { line, column - 1 })
        end
      end
    end,
  },
  lookup_hover = {
    make_request = function(ns, sym)
      return {
        op = "lookup",
        sym = sym,
        ns = ns,
      }
    end,
    callback = function(response, _)
      local opts = {
        title = "nREPL hover",
        focus_id = "nvim.nrepl.hover",
      }
      if response.info and not vim.tbl_isempty(response.info) then
        util.open_floating_preview(util.doc_clj(response.info), "markdown", { title = "" })
      else
        util.open_floating_preview({ "No lookup doc info" }, "", opts)
      end
    end,
  },
  info_hover = {
    make_request = function(ns, sym)
      return {
        op = "info",
        sym = sym,
        ns = ns,
      }
    end,
    callback = function(response, _)
      local opts = {
        title = "nREPL hover",
        focus_id = "nvim.nrepl.hover",
      }
      if response.member then
        util.open_floating_preview(util.doc_java(response), "markdown", opts)
      elseif response.name then
        util.open_floating_preview(util.doc_clj(response), "markdown", opts)
      else
        util.open_floating_preview({ "No lookup doc info" }, "", opts)
      end
    end,
  },
}

for _, tbl in pairs(M.message) do
  setmetatable(tbl, {
    __call = M.write,
  })
end

---@param response table
local function read_callback(response)
  if config.debug then vim.schedule(function() util.echo("DEBUG READ CALLBACK", response) end) end

  local msg_data = response.id and state.data.msgs[response.id]
  if msg_data then
    local status = response.status and util.status(response.status) or {}

    vim.schedule(function() msg_data.callback(response, msg_data.request) end)

    if status.is_done then state.data.msgs[response.id] = nil end
  end
end

---@return uv.uv_tcp_t?
function M.connect(host, port)
  ---@diagnostic disable-next-line
  local addrinfo = vim.uv.getaddrinfo(host, nil, {
    family = "inet",
    protocol = "tcp",
  })[1]
  if addrinfo == nil then
    vim.notify("Failed to get address info", vim.log.levels.WARN)
    return
  end

  local client = vim.uv.new_tcp("inet")
  if client == nil then
    vim.notify("Failed to create TCP server", vim.log.levels.WARN)
    return
  end

  client:connect(addrinfo.addr, port, function(conn_err)
    assert(not conn_err, conn_err)
    vim.notify("nREPL client connected")

    client:read_start(function(read_err, chunk)
      assert(not read_err, read_err)
      if chunk then
        local str_buf = state.data.str_buf .. chunk

        while str_buf ~= "" do
          local response, index = bencode.decode(str_buf)
          if response then
            str_buf = string.sub(str_buf, index)
            read_callback(response)
          else
            break
          end
        end

        state.data.str_buf = str_buf
      else
        client:close()
      end
    end)

    vim.schedule(function()
      M.message.describe()
      M.message.session_refresh()
    end)
  end)
  return client
end

return M
