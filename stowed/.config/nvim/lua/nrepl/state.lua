---@class Nrepl.State.Server
---@field ops? table
---@field sessions? string[]

---@class Nrepl.State.Msgs
---@field op string
---@field out string[]
---@field data table
---@field callback Nrepl.Message.Callback

---@class Nrepl.State
---@field server Nrepl.State.Server
---@field client? uv.uv_tcp_t
---@field session? string
---@field msgs? table<string, Nrepl.State.Msgs>
---@field msg_count? integer
---@field filetype? string

local M = {}

---@type Nrepl.State
M.default = {
  server = {},
  msgs = {},
  msg_count = 0,
  -- HACK will need to change if supporting other languages
  filetype = "clojure",
}

function M.reset() M.data = vim.deepcopy(M.default) end

---@type Nrepl.State
M.data = vim.deepcopy(M.default)

return M
