---@class Nrepl.State.Server
---@field ops? table
---@field sessions? string[]

---@class Nrepl.State
---@field server Nrepl.State.Server
---@field client? uv.uv_tcp_t
---@field session? string
---@field filetype? string

---@type Nrepl.State
local M = {
  server = {},
  -- HACK will need to chage if supporting other languages
  filetype = "clojure"
}

return M
