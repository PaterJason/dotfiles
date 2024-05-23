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
  local args = vim.list_slice(fargs, 2)

  require("nrepl.client").write(client, {
    op = op,
  })
end, {
  range = true,
  nargs = "+",
  complete = function(arg_lead, cmd_line, cursor_pos)
    return vim.tbl_keys(STATE.ops)
  end,
})
