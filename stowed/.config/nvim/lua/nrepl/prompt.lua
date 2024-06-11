local state = require("nrepl.state")

local M = {}

local augroup = vim.api.nvim_create_augroup("nrepl_prompt", { clear = true })

---@return integer
function M.get_buf()
  local bufname = "nREPL-prompt"
  local buf = vim.fn.bufnr(bufname)

  if buf == -1 then
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, bufname)
    vim.bo[buf].buftype = "prompt"

    vim.fn.prompt_setprompt(buf, "=> ")
    vim.fn.prompt_setcallback(buf, "v:lua.require'nrepl.tcp'.message.eval_text")
    vim.fn.prompt_setinterrupt(buf, "v:lua.require'nrepl.tcp'.message.interrupt")

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      group = augroup,
      buffer = buf,
      callback = function()
        vim.treesitter.start(buf, state.data.filetype)
        vim.bo[buf].omnifunc = "v:lua.require'nrepl'.completefunc"
      end,
    })
  end
  return buf
end

---@param s string
---@param opts { new_line?: boolean, prefix?: string }
function M.append(s, opts)
  local buf = M.get_buf()

  local text = vim.split(s, "\n", { plain = true })
  local prefix = opts.prefix and ("; " .. opts.prefix)
  local prefixed_text = {}
  for index, value in ipairs(text) do
    if not prefix or value == "" then
      prefixed_text[index] = value
    else
      prefixed_text[index] = prefix .. value
    end
  end

  local linenr = -1
  if vim.api.nvim_win_get_buf(0) == buf and vim.startswith(vim.api.nvim_get_mode().mode, "i") then
    linenr = -2
  end
  local line = vim.api.nvim_buf_get_lines(buf, linenr - 1, linenr, false)[1]
  if opts.new_line and ((s == "" and line ~= "") or text[#text] ~= "") then
    table.insert(prefixed_text, "")
  end
  local prompt = vim.fn.prompt_getprompt(buf)

  if line == "" then
    vim.api.nvim_buf_set_text(buf, linenr, -1, linenr, -1, prefixed_text)
  elseif
    (not vim.startswith(line, prompt))
    and ((prefix and vim.startswith(line, prefix)) or (not vim.startswith(line, "; ")))
  then
    prefixed_text[1] = text[1]
    vim.api.nvim_buf_set_text(buf, linenr, -1, linenr, -1, prefixed_text)
  else
    vim.api.nvim_buf_set_lines(buf, linenr, linenr, true, prefixed_text)
  end

  local line_count = vim.api.nvim_buf_line_count(buf)
  for _, winnr in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_set_cursor(winnr, { line_count, 0 })
  end
end

return M
