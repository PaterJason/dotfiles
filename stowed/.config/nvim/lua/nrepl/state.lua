---@class Nrepl.State.Server
---@field ops? table
---@field sessions? string[]

---@class Nrepl.State
---@field server Nrepl.State.Server
---@field client? uv.uv_tcp_t
---@field session? string
---@field eval_ids? table<string, true>

---@type Nrepl.State
local M = {
  server = {},
}

return M
