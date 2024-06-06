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
        op = request.op,
        out = {},
        data = {},
        callback = message.callback,
      }
    end
  end)
end

---@alias Nrepl.Message.Callback fun(data: table, op: string)

---@class Nrepl.Message
---@field make_request fun(...: any):table?
---@field callback Nrepl.Message.Callback
---@overload fun(...: any)

local function eval_callback(response, op, no_log_cb)
  for _, key in ipairs({
    "value",
    "nrepl.middleware.caught/throwable",
    "ex",
  }) do
    if response[key] then
      local s = response[key]
      local _, winid = util.append_log(response.session, s, op, key)

      if not winid then no_log_cb(s, key) end
      break
    end
  end
end

M.message = {
  ---@type Nrepl.Message
  describe = {
    make_request = function()
      return {
        op = "describe",
        ["verbose?"] = 1,
      }
    end,
    callback = function(response)
      if response.ops then state.data.server.ops = response.ops end
    end,
  },
  ---@type Nrepl.Message
  session_refresh = {
    make_request = function()
      return {
        op = "ls-sessions",
      }
    end,
    callback = function(response)
      if response.sessions then
        state.data.server.sessions = response.sessions
        if not vim.list_contains(response.sessions, state.data.session) then
          state.data.session = response.sessions[1]
        end
      end
    end,
  },
  ---@type Nrepl.Message
  clone = {
    make_request = function(session)
      return {
        op = "clone",
        session = session or vim.NIL,
      }
    end,
    callback = function(response) M.message.session_refresh() end,
  },
  close = {
    make_request = function(session)
      return {
        op = "close",
        session = session,
      }
    end,
    callback = function(response) M.message.session_refresh() end,
  },

  ---@type Nrepl.Message
  eval_range = {
    ---@param start [integer, integer]
    ---@param end_ [integer, integer]
    make_request = function(start, end_)
      local node = util.get_ts_node("elem", {
        start = start,
        end_ = end_,
        last = true,
      })
      if node == nil then
        util.open_floating_preview({ "No element found at position" })
        return
      end
      local text = vim.treesitter.get_node_text(node, 0)
      local row, col = node:start()
      local file = vim.fn.expand("%:p")

      return {
        op = "eval",
        code = text,
        ns = util.get_ts_text("ns"),
        file = file,
        line = row + 1,
        column = col + 1,
      }
    end,
    callback = function(response, op)
      eval_callback(
        response,
        op,
        function(s, key)
          util.open_floating_preview(
            vim.split(s, "\n", { plain = true }),
            (util.is_ft_key(key) and state.data.filetype) or "",
            { title = "nREPL " .. util.format_log_prefix(op, key) }
          )
        end
      )
    end,
  },
  ---@type Nrepl.Message
  eval_text = {
    make_request = function(text)
      return {
        op = "eval",
        code = text,
      }
    end,
    callback = function(response, op)
      eval_callback(
        response,
        op,
        function(s, key) util.echo("nREPL " .. util.format_log_prefix(op, key), s) end
      )
    end,
  },
  ---@type Nrepl.Message
  load_file = {
    make_request = function(file_path, lines)
      return {
        op = "load-file",
        file = table.concat(lines, "\n"),
        ["file-path"] = file_path,
        ["file-name"] = vim.fs.basename(file_path),
      }
    end,
    callback = function(response, op)
      eval_callback(
        response,
        op,
        function(s, key) util.echo("nREPL " .. util.format_log_prefix(op, key), s) end
      )
    end,
  },
  interrupt = {
    make_request = function(session)
      return {
        op = "interrupt",
        session = session,
      }
    end,
    callback = function(response) end,
  },

  ---@type Nrepl.Message
  lookup_hover = {
    make_request = function(ns, sym)
      return {
        op = "lookup",
        sym = sym,
        ns = ns,
      }
    end,
    callback = function(response)
      if response.info and not vim.tbl_isempty(response.info) then
        util.open_floating_preview(util.doc_clj(response.info), "markdown")
      else
        util.open_floating_preview({ "No lookup doc info" })
      end
    end,
  },
  ---@type Nrepl.Message
  info_hover = {
    make_request = function(ns, sym)
      return {
        op = "info",
        sym = sym,
        ns = ns,
      }
    end,
    callback = function(response)
      if response.member then
        util.open_floating_preview(util.doc_java(response), "markdown")
      elseif response.name then
        util.open_floating_preview(util.doc_clj(response), "markdown")
      else
        util.open_floating_preview({ "No lookup doc info" })
      end
    end,
  },

  ---@type Nrepl.Message
  lookup_definition = {
    make_request = function(ns, sym)
      return {
        op = "lookup",
        sym = sym,
        ns = ns,
      }
    end,
    callback = function(response)
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
}

local mt = {
  __call = M.write,
}
for _, tbl in pairs(M.message) do
  setmetatable(tbl, mt)
end

---@param response table
local function read_callback(response)
  if config.debug then vim.schedule(function() util.echo("DEBUG READ CALLBACK", response) end) end

  if response.id and state.data.msgs[response.id] then
    local msg_data = state.data.msgs[response.id]
    msg_data.data = vim.tbl_extend("force", msg_data.data, response)

    if response.out then table.insert(msg_data.out, response.out) end

    local status = response.status and util.status(response.status) or {}
    if status.is_done then
      vim.schedule(function()
        if not vim.tbl_isempty(msg_data.out) then
          local s = table.concat(msg_data.out)
          local _, winid = util.append_log(response.session, s, msg_data.op, "out")
          if not winid then util.echo("Nrepl (out)n", s) end
        end

        msg_data.callback(msg_data.data, msg_data.op)

        if not vim.tbl_isempty(status.status_strs) then
          local s = table.concat(status.status_strs, ", ")
          local key = (status.is_error and "error") or "done"
          local _, winid = util.append_log(response.session, s, msg_data.op, key)
          if not winid then util.echo(string.format("Nrepl status (%s)", key), s) end
        end
      end)
      state.data.msgs[response.id] = nil
    end
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

    local str_buf = ""
    client:read_start(function(read_err, chunk)
      assert(not read_err, read_err)
      if chunk then
        str_buf = str_buf .. chunk

        while str_buf ~= "" do
          local response, index = bencode.decode(str_buf)
          if response then
            str_buf = string.sub(str_buf, index)
            read_callback(response)
          else
            break
          end
        end
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
