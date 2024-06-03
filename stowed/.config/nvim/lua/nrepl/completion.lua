local state = require("nrepl.state")
local tcp = require("nrepl.tcp")
local util = require("nrepl.util")

local M = {}

---@param prefix string
---@param ns? string
---@return any[]|nil
function M.get_sync(prefix, ns)
  ---@type any[]|nil
  local completions

  state.data.complete_sync_callback = function(items) completions = items end

  -- if state.data.server.ops["complete"] then
  if false then
    tcp.write(state.data.client, {
      op = "complete",
      id = util.msg_id.complete_sync,
      prefix = prefix,
      ns = ns,
      ["extra-metadata"] = { "arglists", "doc" },
    })
  else
    tcp.write(state.data.client, {
      op = "completions",
      id = util.msg_id.complete_sync,
      prefix = prefix,
      ns = ns,
      options = { ["extra-metadata"] = { "arglists", "doc" } },
    })
  end

  vim.wait(5000, function() return completions and true or false end, 100)
  state.data.complete_sync_callback = nil
  return completions
end

local function convert_nrepl_item(item)
  return {
    word = item.candidate,
    info = item.doc,
    menu = item.ns and string.format("%s/%s", item.ns, item.candidate),
    kind = item.type,
  }
end

function M.completefunc(findstart, base)
  if findstart == 1 then
    local pos = vim.api.nvim_win_get_cursor(0)
    pos[2] = pos[2] - 1
    local node = util.get_ts_node("sym", { pos = pos })
    if node then
      local row, column = node:start()
      if row == pos[1] - 1 then return column end
    end
  elseif findstart == 0 then
    local completions = M.get_sync(base, util.get_ts_text("ns"))
    return vim.iter(completions):map(convert_nrepl_item):totable()
  end
end

function M.command_customlist(arg_lead, cmd_line, cursor_pos)
  local completions = M.get_sync(arg_lead)
  local candidates = vim
    .iter(completions)
    :map(function(completion) return completion.candidate end)
    :totable()
  return candidates
end

return M
