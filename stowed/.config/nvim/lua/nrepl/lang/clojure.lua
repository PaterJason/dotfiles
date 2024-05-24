vim.api.nvim_buf_create_user_command(0, "NreplConnect", function(info)
  local host, port = unpack(info.fargs)
  host = host or "127.0.0.1"
  if port == nil then
    for line in io.lines(".nrepl-port") do
      if line then
        port = tonumber(line)
        break
      end
    end
  end

  ---@type uv.uv_tcp_t
  CLIENT = require("nrepl.client").connect(host, port)
end, {})

vim.api.nvim_buf_create_user_command(0, "NreplOp", function(info)
  local client = CLIENT

  local fargs = info.fargs
  local op = fargs[1]

  local data = {
    op = op,
  }

  local args = vim.list_slice(fargs, 2)
  for _, arg in ipairs(args) do
    local n = string.find(arg, "=", 2, true)
    local key = string.sub(arg, 0, n - 1)
    local value = string.sub(arg, n + 1)
    if key ~= "" and value ~= "" then data[key] = value end
  end

  require("nrepl.client").write(client, data)
end, {
  nargs = "+",
  complete = function(arg_lead, cmd_line, cursor_pos)
    local _, arg_n = string.gsub(string.sub(cmd_line, 1, cursor_pos), " ", "")
    if arg_n == 1 then
      return vim
        .iter(STATE.ops)
        :map(function(key, value)
          if string.sub(key, 1, string.len(arg_lead)) == arg_lead then return key end
        end)
        :totable()
    else
      local op = vim.split(cmd_line, " ", { plain = true })[2]

      -- return vim
      --   .iter(STATE.ops[op])
      --   :map(function(key, value)
      --     if string.sub(key, 1, string.len(arg_lead)) == arg_lead then return key end
      --   end)
      --   :totable()
    end
  end,
})

vim.api.nvim_buf_create_user_command(0, "NreplLog", function(info)
  local buf = require("nrepl.log").get_buf()
  vim.cmd({ cmd = "buffer", args = { tostring(buf) } })
end, {
  nargs = 0,
})
