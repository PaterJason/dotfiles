local bencode = require("nrepl.bencode")

local M = {}

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
    client:read_start(function(err, bdata)
      assert(not err, err)
      if bdata then
        vim.schedule(function()
          local data, _ = bencode.decode(bdata)
          vim.print("READING", data)
        end)
      else
        client:close()
      end
    end)
  end)
  return client
end

---@param client uv.uv_tcp_t
---@param obj any
function M.write(client, obj)
  local data = bencode.encode(obj)
  client:write(data, function(err)
    if err then vim.print("Write ERROR", err) end
  end)
end

return M
