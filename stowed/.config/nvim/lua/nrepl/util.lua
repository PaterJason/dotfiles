local state = require("nrepl.state")
local config = require("nrepl.config")
local M = {}

---@alias Nrepl.TSCapture
---| "ns"
---| "sym"
---| "elem"

---@class Nrepl.TSCaptureOpts
---@field start? [integer, integer]
---@field end_? [integer, integer]
---@field last? boolean

---@param capture Nrepl.TSCapture
---@param opts? Nrepl.TSCaptureOpts
---@return TSNode?
function M.get_ts_node(capture, opts)
  opts = opts or {}
  local start
  local end_
  if opts.start then
    start = opts.start
    end_ = opts.end_ or start
  end

  local filetype = state.data.filetype or ""
  local lang = vim.treesitter.language.get_lang(filetype)
  if lang == nil then return end
  local query = vim.treesitter.query.get(lang, "nrepl")
  if query == nil then return end
  local parser = vim.treesitter.get_parser(0, lang, {})
  local tree = parser:trees()[1]

  local return_node
  for id, node in query:iter_captures(tree:root(), 0, start and start[1], end_ and end_[1] + 1) do
    local name = query.captures[id]
    if name == capture then
      if
        (not start or vim.treesitter.is_in_node_range(node, start[1], start[2]))
        and (not end_ or vim.treesitter.is_in_node_range(node, end_[1], end_[2]))
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
        .. (info.class and (info.class .. "/") or "")
        .. info.member
    )
    if info["annotated-arglists"] then vim.list_extend(content, info["annotated-arglists"]) end
    if info.throws and not (vim.tbl_isempty(info.throws)) then
      table.insert(content, string.format("throws %s", table.concat(info.throws, " ")))
    end
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

---@param title string
---@param data any
function M.echo(title, data)
  vim.api.nvim_echo({
    { title .. "\n", "Underlined" },
    { (type(data) == "string" and data) or vim.inspect(data), "Normal" },
  }, true, {})
end

M.callback = {}

---@type Nrepl.Message.Callback
function M.callback.status(response, request)
  local status = response.status and M.status(response.status) or {}

  if status.is_done and not vim.tbl_isempty(status.status_strs) then
    local s = table.concat(status.status_strs, ", ")
    require("nrepl.prompt").append(response.session, s, {
      new_line = true,
      prefix = string.format("%s (%s) ", request.op, status.is_error and "error" or "done"),
    })
  end
end

---@type Nrepl.Message.Callback
function M.callback.eval(response, request)
  local prompt = require("nrepl.prompt")

  if response.out then
    prompt.append(response.session, response.out, { prefix = "(out) " })
    vim.cmd({ cmd = "echo" })
    -- vim.api.nvim_echo({ { response.out, "Comment" } }, false, {})
    vim.cmd("echo '22222'")
  elseif response.err then
    prompt.append(response.session, response.err, { prefix = "(err) " })
    vim.api.nvim_out_write(response.err)
    -- vim.api.nvim_echo({ { response.err, "ErrorMsg" } }, false, {})
  elseif response.value then
    prompt.append(response.session, response.value, {})
    vim.api.nvim_out_write(response.value)
    -- vim.api.nvim_echo({ { response.value, "Normal" } }, false, {})
  end

  local status = response.status and M.status(response.status) or {}
  if status.is_done and not vim.tbl_isempty(status.status_strs) then
    M.callback.status(response, request)
  elseif status.is_done then
    prompt.append(response.session, "", { new_line = true })
    -- vim.api.nvim_out_write("\n")
  end
end

return M
