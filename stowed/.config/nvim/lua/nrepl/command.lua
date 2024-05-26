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
    local ops = require("nrepl.state").server.ops
    return vim
      .iter(ops)
      :map(function(key, value)
        if value.requires == nil or vim.tbl_isempty(value.requires) then return key end
      end)
      :filter(util.filter_completion_pred(arg_lead, cmd_line, cursor_pos))
      :totable()
  end,
})

vim.api.nvim_create_user_command("NreplWrite", function(info)
  local client = require("nrepl.state").client
  if client == nil then
    vim.notify("No nREPL client connected", vim.log.levels.WARN)
    return
  end

  local args = info.args
  local data = vim.fn.eval(args)
  require("nrepl.tcp").write(client, data)
end, {
  nargs = 1,
  complete = "expression",
})

local action = require("nrepl.action")
vim.api.nvim_create_user_command("Nrepl", function(info)
  local fargs = info.fargs
  local key = table.remove(fargs, 1)
  action[key](unpack(fargs))
end, {
  nargs = "+",
  complete = function(arg_lead, cmd_line, cursor_pos)
    local _, arg_n = string.gsub(string.sub(cmd_line, 1, cursor_pos), " ", "")
    local server = require("nrepl.state").server
    if arg_n == 1 then
      return vim
        .iter(action)
        :map(function(key, _) return key end)
        :filter(util.filter_completion_pred(arg_lead, cmd_line, cursor_pos))
        :totable()
    elseif arg_n == 2 and server then
      local act = vim.split(cmd_line, " ", { plain = true })[2]
      if vim.list_contains({ "set_session", "clone", "close", "log" }, act) then
        return vim
          .iter(server.sessions)
          :map(function(key, _) return key end)
          :filter(util.filter_completion_pred(arg_lead, cmd_line, cursor_pos))
          :totable()
      end
    end
  end,
})
