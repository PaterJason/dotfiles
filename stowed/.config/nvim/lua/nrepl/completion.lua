local state = require("nrepl.state")
local tcp = require("nrepl.tcp")
local util = require("nrepl.util")

local M = {}

C = {
  arglists = { "[s]", "[opts s]" },
  candidate = "edn/read-string",
  doc = "Reads one object from the string s. Returns nil when s is nil or empty.\n\n  Reads data in the edn format (subset of Clojure data):\n  http://edn-format.org\
n\n  opts is a map as per clojure.edn/read",
  ns = "clojure.edn",
  type = "function",
}

---@param prefix string
---@param ns? string
---@return any[]|nil
function M.get_sync(prefix, ns)
  ---@type any[]|nil
  local completions

  state.complete_sync_callback = function(items) completions = items end
  tcp.write(state.client, {
    op = "completions",
    id = util.msg_id.complete_sync,
    prefix = prefix,
    -- util.get_ts_text("ns")
    ns = ns,
    options = { ["extra-metadata"] = { "arglists", "doc" } },
  })

  vim.wait(5000, function() return completions and true or false end, 100)
  state.complete_sync_callback = nil
  return completions
end

function M.command(arg_lead, cmd_line, cursor_pos)
  local completions = M.get_sync(arg_lead)
  local candidates = vim
    .iter(completions)
    :map(function(completion) return completion.candidate end)
    :totable()
  return candidates
end

return M
