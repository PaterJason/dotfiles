local bencode = require("nrepl.bencode")
local util = require("nrepl.util")
local state = require("nrepl.state")
local config = require("nrepl.config")

local M = {}

---@param operation Nrepl.Operation
---@param ... unknown
function M.write_operation(operation, ...)
  local client = state.data.client
  if not client then
    vim.notify("No nREPL client connected", vim.log.levels.WARN)
    return
  elseif not client:is_writable() then
    vim.notify("Cannot write to nREPL server", vim.log.levels.WARN)
    return
  end

  local obj = operation.make_operation(...)
  if not obj then return end
  obj = vim.tbl_extend("keep", obj, config.middleware_params, {
    id = "nvim:" .. state.data.msg_count,
    session = state.data.session,
  })
  state.data.msg_count = state.data.msg_count + 1

  if config.debug then vim.schedule(function() util.echo("DEBUG WRITE CALLBACK", obj) end) end

  local data = bencode.encode(obj)
  if not data then return end
  client:write(data, function(err)
    assert(not err, err)
    if obj.id then
      state.data.msgs[obj.id] = {
        op = obj.op,
        out = {},
        data = {},
        callback = operation.callback,
      }
    end
  end)
end

---@alias Nrepl.Operation.Callback fun(data: table, op: string)

---@class Nrepl.Operation
---@field make_operation fun(...: any):table?
---@field callback Nrepl.Operation.Callback
---@overload fun(...: any)

local function eval_callback(data, op, no_log_cb)
  for _, key in ipairs({
    "value",
    "nrepl.middleware.caught/throwable",
    "ex",
  }) do
    if data[key] then
      local s = data[key]
      local _, winid = util.append_log(data.session, s, op, key)

      if not winid then no_log_cb(s, key) end
      break
    end
  end
end

M.operation = {
  ---@type Nrepl.Operation
  describe = {
    make_operation = function()
      return {
        op = "describe",
        ["verbose?"] = 1,
      }
    end,
    callback = function(data)
      if data.ops then state.data.server.ops = data.ops end
    end,
  },
  ---@type Nrepl.Operation
  session_refresh = {
    make_operation = function()
      return {
        op = "ls-sessions",
      }
    end,
    callback = function(data)
      if data.sessions then
        state.data.server.sessions = data.sessions
        if not vim.list_contains(data.sessions, state.data.session) then
          state.data.session = data.sessions[1]
        end
      end
    end,
  },
  ---@type Nrepl.Operation
  clone = {
    make_operation = function(session)
      return {
        op = "clone",
        session = session or vim.NIL,
      }
    end,
    callback = function(data) M.operation.session_refresh() end,
  },
  close = {
    make_operation = function(session)
      return {
        op = "close",
        session = session,
      }
    end,
    callback = function(data) M.operation.session_refresh() end,
  },

  ---@type Nrepl.Operation
  eval_range = {
    ---@param start [integer, integer]
    ---@param end_ [integer, integer]
    make_operation = function(start, end_)
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
    callback = function(data, op)
      eval_callback(
        data,
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
  ---@type Nrepl.Operation
  eval_text = {
    make_operation = function(text)
      return {
        op = "eval",
        code = text,
      }
    end,
    callback = function(data, op)
      eval_callback(
        data,
        op,
        function(s, key) util.echo("nREPL " .. util.format_log_prefix(op, key), s) end
      )
    end,
  },
  ---@type Nrepl.Operation
  load_file = {
    make_operation = function(file_path, lines)
      return {
        op = "load-file",
        file = table.concat(lines, "\n"),
        ["file-path"] = file_path,
        ["file-name"] = vim.fs.basename(file_path),
      }
    end,
    callback = function(data, op)
      eval_callback(
        data,
        op,
        function(s, key) util.echo("nREPL " .. util.format_log_prefix(op, key), s) end
      )
    end,
  },
  interrupt = {
    make_operation = function(session)
      return {
        op = "interrupt",
        session = session,
      }
    end,
    callback = function(data) end,
  },

  ---@type Nrepl.Operation
  lookup_hover = {
    make_operation = function(ns, sym)
      return {
        op = "lookup",
        sym = sym,
        ns = ns,
      }
    end,
    callback = function(data)
      if data.info and not vim.tbl_isempty(data.info) then
        util.open_floating_preview(util.doc_clj(data.info), "markdown")
      else
        util.open_floating_preview({ "No lookup doc info" })
      end
    end,
  },
  ---@type Nrepl.Operation
  info_hover = {
    make_operation = function(ns, sym)
      return {
        op = "info",
        sym = sym,
        ns = ns,
      }
    end,
    callback = function(data)
      if data.member then
        util.open_floating_preview(util.doc_java(data), "markdown")
      elseif data.name then
        util.open_floating_preview(util.doc_clj(data), "markdown")
      else
        util.open_floating_preview({ "No lookup doc info" })
      end
    end,
  },

  ---@type Nrepl.Operation
  lookup_definition = {
    make_operation = function(ns, sym)
      return {
        op = "lookup",
        sym = sym,
        ns = ns,
      }
    end,
    callback = function(data)
      if data.info and not vim.tbl_isempty(data.info) then
        local file = data.info.file
        local line = data.info.line
        local column = data.info.column

        if file and line and column then
          vim.cmd({ cmd = "edit", args = { util.file_str(file) } })
          vim.api.nvim_win_set_cursor(0, { line, column - 1 })
        end
      end
    end,
  },
}

local mt = {
  __call = M.write_operation,
}
for _, tbl in pairs(M.operation) do
  setmetatable(tbl, mt)
end

---@param data table
local function read_callback(data)
  if config.debug then vim.schedule(function() util.echo("DEBUG READ CALLBACK", data) end) end

  if data.id and state.data.msgs[data.id] then
    local msg_data = state.data.msgs[data.id]
    msg_data.data = vim.tbl_extend("force", msg_data.data, data)

    if data.out then table.insert(msg_data.out, data.out) end

    local status = data.status and util.status(data.status) or {}
    if status.is_done then
      vim.schedule(function()
        if not vim.tbl_isempty(msg_data.out) then
          local s = table.concat(msg_data.out)
          local _, winid = util.append_log(data.session, s, msg_data.op, "out")
          if not winid then util.echo("Nrepl (out)n", s) end
        end

        msg_data.callback(msg_data.data, msg_data.op)

        if not vim.tbl_isempty(status.status_strs) then
          local s = table.concat(status.status_strs, ", ")
          local key = (status.is_error and "error") or "done"
          local _, winid = util.append_log(data.session, s, msg_data.op, key)
          if not winid then util.echo(string.format("Nrepl status (%s)", key), s) end
        end
      end)
      state.data.msgs[data.id] = nil
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
          local data, index = bencode.decode(str_buf)
          if data then
            str_buf = string.sub(str_buf, index)
            read_callback(data)
          else
            break
          end
        end
      else
        client:close()
      end
    end)

    vim.schedule(function()
      M.operation.describe()
      M.operation.session_refresh()
    end)
  end)
  return client
end

return M
