local util = require("nrepl.util")

vim.api.nvim_create_user_command("NreplOp", function(info)
  local client = require("nrepl.state").client
  if client == nil then
    vim.notify("No nREPL client connected", vim.log.levels.WARN)
    return
  end

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

  require("nrepl.tcp").write(client, data)
end, {
  nargs = "+",
  complete = function(arg_lead, cmd_line, cursor_pos)
    local _, arg_n = string.gsub(string.sub(cmd_line, 1, cursor_pos), " ", "")
    local state = require("nrepl.state")
    if arg_n == 1 then
      local ops = vim.tbl_get(state, "server", "ops")
      if ops == nil then return end
      return vim
        .iter(state.server.ops)
        :map(function(key, _) return key end)
        :filter(util.filter_completion_pred(arg_lead, cmd_line, cursor_pos))
        :totable()
    elseif arg_n > 1 then
      local op = vim.split(cmd_line, " ", { plain = true })[2]
      local op_desc = vim.tbl_get(state, "server", "ops", op)
      if op_desc == nil then return end
      local op_params = {}
      vim.list_extend(op_params, vim.tbl_keys(op_desc.requires))
      vim.list_extend(op_params, vim.tbl_keys(op_desc.optional))

      return vim
        .iter(op_params)
        :filter(util.filter_completion_pred(arg_lead, cmd_line, cursor_pos))
        :totable()
    end
  end,
})

local action = require("nrepl.action")
vim.api.nvim_create_user_command("Nrepl", function(info)
  local fargs = info.fargs
  local key = table.remove(fargs, 1)
  action[key](unpack(fargs))
end, {
  nargs = "+",
  complete = function(arg_lead, cmd_line, cursor_pos)
    return vim
      .iter(action)
      :map(function(key, _) return key end)
      :filter(util.filter_completion_pred(arg_lead, cmd_line, cursor_pos))
      :totable()
  end,
})
