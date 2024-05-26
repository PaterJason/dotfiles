local state = require("nrepl.state")
local config = require("nrepl.config")
local M = {}

---@alias Nrepl.TSCapture
---| "ns"
---| "sym"
---| "elem"

---@class Nrepl.TSCaptureOpts
---@field cursor? boolean
---@field last? boolean

---@param capture Nrepl.TSCapture
---@param opts? Nrepl.TSCaptureOpts
---@return TSNode?
function M.get_ts_node(capture, opts)
  opts = opts or {}
  local filetype = vim.bo.filetype
  local lang = vim.treesitter.language.get_lang(filetype)
  if lang == nil then return end
  local query = vim.treesitter.query.get(lang, "nrepl")
  if query == nil then return end
  local parser = vim.treesitter.get_parser(0, lang, {})
  local tree = parser:trees()[1]

  local cursor_pos
  local start, stop
  if opts.cursor then
    cursor_pos = vim.api.nvim_win_get_cursor(0)
    start = cursor_pos[1] - 1
    stop = cursor_pos[1]
  end

  local return_node
  for id, node in query:iter_captures(tree:root(), 0, start, stop) do
    local name = query.captures[id]
    if name == capture then
      if
        not cursor_pos or vim.treesitter.is_in_node_range(node, cursor_pos[1] - 1, cursor_pos[2])
      then
        if opts.last then
          return_node = node
        else
          return node
        end
      end
    end
  end
  return return_node
end

---@param capture Nrepl.TSCapture
---@param opts? Nrepl.TSCaptureOpts
---@return string?
function M.get_ts_text(capture, opts)
  local node = M.get_ts_node(capture, opts)
  if node then return vim.treesitter.get_node_text(node, 0) end
end

M.msg_id = {
  eval = "nvim-eval",
  load_file = "nvim-load-file",
  lookup_definition = "nvim-lookup-definition",
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

function M.definition(info)
  local file = info.file
  local row = info.line
  local col = info.column - 1

  file = string.gsub(file, "^file:", "", 1)
  file = string.gsub(file, "^jar:file:(.*)(!/)", "zipfile://%1::", 1)

  vim.cmd({ cmd = "edit", args = { file } })
  vim.api.nvim_win_set_cursor(0, { row, col })
end

function M.hover_doc(info)
  local content = {}
  if vim.tbl_isempty(info) then
    table.insert(content, "No doc info found")
  else
    table.insert(content, info.ns .. "/" .. info.name)
    table.insert(content, info["arglists-str"])
    table.insert(content, info.added and "Available since " .. info.added)
    table.insert(content, info.doc)
  end

  vim.lsp.util.open_floating_preview(content, "", config.floating_preview)
end

---@param callback fun(item: string?, idx: integer?)
function M.select_session(callback)
  vim.ui.select(state.server.sessions, {
    prompt = "Select session",
    format_item = function(item)
      local current_session = state.session
      if item == current_session then
        return item .. " (current)"
      else
        return item
      end
    end,
  }, function(item)
    if item then callback(item) end
  end)
end

return M
