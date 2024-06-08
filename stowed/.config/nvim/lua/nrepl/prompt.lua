local state = require("nrepl.state")
local tcp = require("nrepl.tcp")

local M = {}

---@param session? string
function M.get_buf(session)
  session = session or state.data.session
  ---@return integer?

  local bufname = "nREPL-prompt-" .. session
  local buf = vim.fn.bufnr(bufname)

  if buf == -1 then
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, bufname)
    vim.bo[buf].buftype = "prompt"

    vim.fn.prompt_setprompt(buf, "=> ")
    vim.fn.prompt_setcallback(buf, "v:lua.require'nrepl.prompt'.callback")
    vim.fn.prompt_setinterrupt(buf, "v:lua.require'nrepl.action'.interrupt")

    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      buffer = buf,
      callback = function()
        vim.bo[buf].filetype = state.data.filetype
        vim.treesitter.start(buf, state.data.filetype)
        vim.bo[buf].omnifunc = "v:lua.require'nrepl'.completefunc"
      end,
    })
    return buf
  else
    return buf
  end
end

---@param session string
---@param s string
---@param opts { new_line?: boolean, linenr?: number, prefix?: string }
function M.append(session, s, opts)
  local buf = M.get_buf(session)
  if not buf then return end

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
  if opts.new_line then table.insert(prefixed_text, "") end

  local linenr = opts.linenr or -1
  local line = vim.api.nvim_buf_get_lines(buf, linenr - 1, linenr, false)[1]
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
  vim.bo[buf].modified = false
end

function M.callback(text)
  if text == "" then return end
  tcp.write({
    make_request = function()
      return {
        op = "eval",
        code = text,
      }
    end,
    callback = function(response)
      if response.out then
        M.append(response.session, response.out, { prefix = "(out) ", linenr = -2 })
      elseif response.err then
        M.append(response.session, response.err, { prefix = "(err) ", linenr = -2 })
      elseif response.value then
        M.append(response.session, response.value, { linenr = -2 })
      end
    end,
  })
end

return M
