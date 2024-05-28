local M = {}

function M.init()
  require("nrepl.command")
  if vim.tbl_isempty(require("nrepl.state").server) then vim.cmd("Nrepl connect") end
end

return M
