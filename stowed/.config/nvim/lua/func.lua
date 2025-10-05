local M = {}

---@param cmdarg string
---@param _cmdcomplete boolean
---@return string[]
function M.RgFfu(cmdarg, _cmdcomplete)
  local fnames = vim.fn.systemlist('rg --files')
  if #cmdarg == 0 then
    return fnames
  else
    return vim.fn.matchfuzzy(fnames, cmdarg)
  end
end

return M
