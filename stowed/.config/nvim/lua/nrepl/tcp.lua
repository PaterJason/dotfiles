local bencode = require("nrepl.bencode")
local util = require("nrepl.util")
local state = require("nrepl.state")
local config = require("nrepl.config")

local M = {}

---@alias Nrepl.Handler fun(data: any):boolean

---@param handlers Nrepl.Handler[]
---@param data any
local function run_handlers(handlers, data)
  for _, handler in ipairs(handlers) do
    if handler(data) then break end
  end
end

---@type Nrepl.Handler[]
local write_handlers = {
  -- debugging handler
  function(data)
    if config.debug then
      vim.api.nvim_echo({
        { "DEBUG WRITE HANDLER\n", "Underlined" },
        { vim.inspect(data), "Normal" },
      }, true, {})
    end
  end,
  function(data)
    if data.op == "close" then
      local buf = util.get_log_buf(data.session)
      if buf then
        vim.api.nvim_buf_delete(buf, {})
        if state.data.session == data.session then state.data.session = nil end
      end
    end
    return true
  end,
}

---@param client uv.uv_tcp_t
---@param ... any
function M.write(client, ...)
  local objs = { ... }
  local data = ""
  for _, obj in ipairs(objs) do
    obj = vim.tbl_extend("keep", obj, config.middleware_params)
    data = data .. (bencode.encode(obj) or "")
  end
  if data ~= "" then
    client:write(data, function(err)
      if err then
        vim.print("Write ERROR", err)
        return
      end

      for _, obj in ipairs(objs) do
        vim.schedule(function() run_handlers(write_handlers, obj) end)
      end
    end)
  end
end

---@param data any
---@param key string
local function handle_out(data, key)
  local session = data.session
  local msg_id = data.id
  local s = data[key]

  local buf = util.get_log_buf(session)
  if buf then
    util.append_log(buf, s, key)

    -- If log is open in tab
    local winid = vim
      .iter(vim.api.nvim_tabpage_list_wins(0))
      :find(function(winid) return buf == vim.api.nvim_win_get_buf(winid) end)
    if winid then return end
  end

  if msg_id == util.msg_id.eval_cursor then
    local filetype = (key == "value" and state.data.filetype) or ""
    util.cursor_float(s, filetype)
  elseif msg_id == util.msg_id.eval_input then
    vim.api.nvim_echo({ { s, "Normal" } }, true, {})
  end
end

---@type Nrepl.Handler[]
local read_handlers = {
  -- debugging handler
  function(data)
    if config.debug then
      vim.api.nvim_echo({
        { "DEBUG READ HANDLER\n", "Underlined" },
        { vim.inspect(data), "Normal" },
      }, true, {})
    end
  end,
  -- status
  function(data)
    if
      data.status
      and state.data.server.sessions
      and vim.list_contains(state.data.server.sessions, data.session)
    then
      local status = util.status(data.status)
      if status.is_done and not vim.tbl_isempty(status.status_strs) then
        local buf = util.get_log_buf(data.session)
        if buf then
          util.append_log(
            buf,
            table.concat(status.status_strs, ", "),
            (status.is_error and "error") or "done"
          )
        end
      end
      return false
    end
  end,
  -- op: describe
  function(data)
    if data.ops then
      state.data.server.ops = data.ops
      return true
    end
  end,
  -- op: ls-sessions
  function(data)
    if data.id == util.msg_id.session_refresh and data.sessions then
      state.data.server.sessions = data.sessions
      if state.data.session == nil then state.data.session = data.sessions[1] end
      return true
    end
  end,
  -- op: sessions
  function(data)
    if data.id == util.msg_id.session_modify then
      M.write(state.data.client, {
        op = "ls-sessions",
        id = util.msg_id.session_refresh,
      })
      return true
    end
  end,
  -- out
  function(data)
    if data.out then
      local buf = util.get_log_buf(data.session)
      if buf then util.append_log(buf, data.out, "out") end
      return true
    end
  end,
  -- error
  function(data)
    if data.err then
      handle_out(data, "err")
      return true
    end
  end,
  -- op: eval
  function(data)
    if data.value then
      handle_out(data, "value")
      return true
    elseif data.ex then
      return true
    end
  end,
  -- op: lookup, definition
  function(data)
    if data.id == util.msg_id.lookup_definition and data.info then
      util.definition(data.info)
      return true
    end
  end,
  -- op: lookup, hover
  function(data)
    if data.id == util.msg_id.lookup_hover and data.info then
      util.hover_doc(data.info)
      return true
    end
  end,
  -- op: completion, sync
  function(data)
    if
      data.id == util.msg_id.complete_sync
      and state.data.complete_sync_callback
      and data.completions
    then
      state.data.complete_sync_callback(data.completions)
      return true
    end
  end,
}

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

    local str_buf = ""
    client:read_start(function(read_err, chunk)
      assert(not read_err, read_err)
      if chunk then
        str_buf = str_buf .. chunk

        while str_buf ~= "" do
          local data, index = bencode.decode(str_buf)
          if data then
            str_buf = string.sub(str_buf, index)
            vim.schedule(function() run_handlers(read_handlers, data) end)
          else
            break
          end
        end
      else
        client:close()
      end
    end)

    vim.schedule(
      function()
        M.write(
          client,
          { op = "describe", ["verbose?"] = 1 },
          { op = "ls-sessions", id = util.msg_id.session_refresh }
        )
      end
    )
  end)
  return client
end

return M
