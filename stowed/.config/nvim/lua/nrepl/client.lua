local bencode = require("nrepl.bencode")
local log = require("nrepl.log")

local M = {}

---@class Nrepl.State
---@field ops table
---@field sessions string[]
STATE = {}

---@alias Nrepl.Handler fun(data: any):boolean

---@type Nrepl.Handler[]
M.handlers = {
  -- op: describe
  function(data)
    if data.ops then
      STATE.ops = data.ops
      return true
    end
  end,
  -- op: ls-sessions
  function(data)
    if data.sessions then
      STATE.sessions = data.sessions
      return true
    end
  end,
  -- op: eval, value
  function(data)
    if data.value then
      local buf = log.get_buf()
      vim.api.nvim_buf_set_lines(buf, -1, -1, false, { data.value })
      return true
    end
  end,
  -- Fallback
  function(data) vim.print("READING", data) end,
}

---@param data any
function M.run_handlers(data)
  for _, handler in ipairs(M.handlers) do
    if handler(data) then break end
  end
end

---@param client uv.uv_tcp_t
---@param obj any
function M.write(client, obj)
  local data = bencode.encode(obj)
  client:write(data, function(err)
    if err then vim.print("Write ERROR", err) end
  end)
end

---@return uv.uv_tcp_t?
function M.connect(host, port)
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

  client:connect(host, port, function(err)
    assert(not err, err)

    str_buf = ""
    client:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        str_buf = str_buf .. chunk

        while str_buf ~= "" do
          local data, index = bencode.decode(str_buf)
          if data then
            str_buf = string.sub(str_buf, index)
            vim.schedule(function() M.run_handlers(data) end)
          else
            break
          end
        end
      else
        client:close()
      end
    end)

    vim.schedule(function()
      M.write(client, { op = "describe", ["verbose?"] = 1 })
      M.write(client, { op = "ls-sessions" })
    end)
  end)
  return client
end

return M
