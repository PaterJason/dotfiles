local state = require("nrepl.state")
local config = require("nrepl.config")
local M = {}

M.msg_id = {
  lookup_hover = "nvim-lookup-hover",
  session_modify = "nvim-session-modify",
  session_refresh = "nvim-session-refresh",
}

---@param session? string
---@return integer
function M.get_log_buf(session)
  session = session or state.session
  local bufname = "nREPL-log-" .. session
  local buf = vim.fn.bufnr(bufname)

  if buf == -1 then
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, bufname)
    return buf
  else
    return buf
  end
end

function M.append_log(session, s)
  local buf = M.get_log_buf(session)
  local text = vim.split(s, "\n", { plain = true })
  vim.api.nvim_buf_set_lines(buf, -1, -1, false, text)
end

function M.filter_completion_pred(arg_lead, cmd_line, cursor_pos)
  return function(value) return string.sub(value, 1, string.len(arg_lead)) == arg_lead end
end

function M.hover_doc(info)
  local content = {
    info.ns .. "/" .. info.name,
  }
  if info["arglists-str"] then table.insert(content, info["arglists-str"]) end
  if info.added then table.insert(content, "Available since " .. info.added) end
  if info.doc then table.insert(content, info.doc) end

  vim.lsp.util.open_floating_preview(content, "", config.floating_preview)
end

return M
