---@class Nrepl.State.Server
---@field ops? table
---@field sessions? string[]

---@class Nrepl.State
---@field server Nrepl.State.Server
---@field client? uv.uv_tcp_t
---@field session? string
---@field filetype? string
---@field complete_sync_callback? fun(data: any[])

local M = {}

---@type Nrepl.State
M.default = {
  server = {},
  -- HACK will need to resolve if supporting other languages
  filetype = "clojure",
}

function M.reset() M.data = vim.deepcopy(M.default) end

---@type Nrepl.State
M.data = vim.deepcopy(M.default)

return M
