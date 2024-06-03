local state = require("nrepl.state")
local config = require("nrepl.config")
local M = {}

---@alias Nrepl.TSCapture
---| "ns"
---| "sym"
---| "elem"

---@class Nrepl.TSCaptureOpts
---@field cursor? boolean
---@field pos? integer[]
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

  local pos
  if opts.pos then
    pos = opts.pos
  elseif opts.cursor then
    pos = vim.api.nvim_win_get_cursor(0)
  end

  local return_node
  for id, node in query:iter_captures(tree:root(), 0, pos and pos[1] - 1, pos and pos[1]) do
    local name = query.captures[id]
    if name == capture then
      if not pos or vim.treesitter.is_in_node_range(node, pos[1] - 1, pos[2]) then
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
  complete_sync = "nvim-complete-sync",
  eval_cursor = "nvim-eval-cursor",
  eval_input = "nvim-eval-input",
  load_file = "nvim-load-file",
  lookup_definition = "nvim-lookup-definition",
  lookup_hover = "nvim-lookup-hover",
  session_modify = "nvim-session-modify",
  session_refresh = "nvim-session-refresh",

  cider_info_hover = "nvim-cider-info-hover",
}

---@param status string[]
---@return { is_done: boolean, is_error: boolean, status_strs: string[] }
function M.status(status)
  return vim.iter(status):fold({
    is_done = false,
    is_error = false,
    status_strs = {},
  }, function(acc, s)
    if s == "done" then
      acc.is_done = true
    elseif s == "error" then
      acc.is_error = true
    else
      table.insert(acc.status_strs, s)
    end
    return acc
  end)
end

---@param session? string
---@return integer?
function M.get_log_buf(session)
  session = session or state.data.session
  if not vim.list_contains(state.data.server.sessions, session) then return end
  local bufname = "nREPL-log-" .. session
  local buf = vim.fn.bufnr(bufname)

  if buf == -1 then
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, bufname)

    vim.bo[buf].filetype = state.data.filetype
    return buf
  else
    return buf
  end
end

function M.is_ft_key(key)
  return vim.list_contains({
    "value",
    "nrepl.middleware.caught/throwable",
  }, key)
end

local function format_log_comment(buf, key, value)
  local commentstring = vim.bo[buf].commentstring
  return string.format(
    commentstring,
    (key and string.format("(%s)", key) or "") .. (value and string.format(" %s", value) or "")
  )
end

---@param buf integer
---@param s string
---@param key? string
function M.append_log(buf, s, key)
  s = string.gsub(s, "\n$", "")
  local text = vim.split(s, "\n", { plain = true })

  local start = -1
  if vim.api.nvim_buf_get_lines(buf, -2, -1, false)[1] == "" then start = -2 end
  local pre_line_count = vim.api.nvim_buf_line_count(buf)

  if M.is_ft_key(key) then
    table.insert(text, 1, format_log_comment(buf, key))
    vim.api.nvim_buf_set_lines(buf, start, -1, true, text)
  else
    local text2 = {}
    for _, value in ipairs(text) do
      table.insert(text2, format_log_comment(buf, key, value))
    end
    vim.api.nvim_buf_set_lines(buf, start, -1, true, text2)
  end

  local post_line_count = vim.api.nvim_buf_line_count(buf)
  for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if
      buf == vim.api.nvim_win_get_buf(winid)
      and pre_line_count <= vim.api.nvim_win_get_cursor(winid)[1]
    then
      vim.api.nvim_win_set_cursor(winid, { post_line_count, 0 })
    end
  end
end

---@diagnostic disable-next-line: unused-local
function M.filter_completion_pred(arg_lead, cmd_line, cursor_pos)
  return function(value) return string.sub(value, 1, string.len(arg_lead)) == arg_lead end
end

---@param file string
---@return string
function M.file_str(file)
  file = string.gsub(file, "^file:", "", 1)
  file = string.gsub(file, "^jar:file:(.*)(!/)", "zipfile://%1::", 1)
  return file
end

---@param info any
---@return string[]
function M.doc_clj(info)
  local content = {}
  if vim.tbl_isempty(info) then
    table.insert(content, "No lookup doc info")
  else
    -- Look at clojure.repl/print-doc
    table.insert(content, "```clojure")
    table.insert(content, (info.ns and info.ns .. "/" .. info.name) or info.name)
    table.insert(content, info.arglists or info["arglists-str"])
    table.insert(content, info["forms-str"])
    table.insert(content, "```")

    table.insert(content, (info["special-form"] and "Special Form") or (info.macro and "Macro"))
    table.insert(content, info.added and "Available since " .. info.added)
    table.insert(content, info.doc and " " .. info.doc)

    if info["see-also"] then
      vim.list_extend(content, { "", "__See also:__", "```clojure" })
      vim.list_extend(content, info["see-also"])
      table.insert(content, "```")
    end
    if info.file then
      vim.list_extend(content, { "", "__File:__", string.format("[%s]", M.file_str(info.file)) })
    end
  end
  return content
end

---@param info any
---@return string[]
function M.doc_java(info)
  local content = {}
  if vim.tbl_isempty(info) then
    table.insert(content, "No lookup doc info")
  else
    table.insert(content, "```clojure")
    table.insert(
      content,
      (info.modifiers and (info.modifiers .. " ") or "")
        .. (info.returns and (info.returns .. " ") or "")
        .. (info.type and (info.type .. " ") or "")
        .. (info.class and (info.class .. "/") or "")
        .. info.member
    )
    table.insert(content, info.arglists or info["arglists-str"])
    table.insert(content, "```")

    if info.javadoc then
      vim.list_extend(content, { "__Javadoc:__", string.format("[%s]", info.javadoc) })
    end
  end
  return content
end

---@param contents string[]
---@param filetype? string
---@param opts? vim.lsp.util.open_floating_preview.Opts
function M.open_floating_preview(contents, filetype, opts)
  filetype = filetype or ""
  opts = opts or {}
  local bufnr, _ = vim.lsp.util.open_floating_preview(
    contents,
    filetype,
    vim.tbl_extend("keep", opts, config.floating_preview)
  )

  local lang = vim.treesitter.language.get_lang(filetype)
  if lang then vim.treesitter.start(bufnr, lang) end
end

---@param callback fun(item: string?, idx: integer?)
function M.select_session(callback)
  vim.ui.select(state.data.server.sessions, {
    prompt = "Select session",
    format_item = function(item)
      local current_session = state.data.session
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
