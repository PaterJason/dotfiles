local M = {}

function M.init()
  require("nrepl.command")
  if vim.tbl_isempty(require("nrepl.state").data.server) then vim.cmd("Nrepl connect") end
end

function M.completefunc(...) return require("nrepl.completion").completefunc(...) end

function M.command_completion_customlist(...)
  return require("nrepl").command_completion_customlist(...)
end

return M
