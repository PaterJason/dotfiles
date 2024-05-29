---@class Nrepl.State.Server
---@field ops? table
---@field sessions? string[]

---@class Nrepl.State
---@field server Nrepl.State.Server
---@field client? uv.uv_tcp_t
---@field session? string
---@field filetype? string
---@field complete_sync_callback? fun(data: any[])

---@type Nrepl.State
local default = {
  server = {},
  -- HACK will need to chage if supporting other languages
  filetype = "clojure",
}

---@type Nrepl.State
local M = default

return M
