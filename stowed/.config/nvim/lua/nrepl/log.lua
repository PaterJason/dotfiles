local M = {}

local log_bufname = "NREPL"

---@return integer
function M.get_buf()
  local buf = vim.fn.bufnr(log_bufname)

  if buf == -1 then
    buf = vim.api.nvim_create_buf(false, true)
    local bufname = log_bufname
    vim.api.nvim_buf_set_name(buf, bufname)
    return buf
  else
    return buf
  end
end

return M
