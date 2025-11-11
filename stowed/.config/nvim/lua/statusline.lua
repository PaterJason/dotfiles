local function diagnostic()
  if package.loaded['vim.diagnostic'] == nil then return '' end
  local counts = vim.diagnostic.count(0)
  local signs = require('icons').diagnostic
  local hls = require('icons').diagnostic_hl
  local result_str = vim
    .iter(pairs(counts))
    :map(
      function(severity, count) return ('%%#%s#%s%s'):format(hls[severity], signs[severity], count) end
    )
    :join(' ')
  return result_str .. '%#StatusLine# '
end

local ruler = '%-14.(%l,%c%V%) %P'

--- Default:
--- %<%f %h%w%m%r %=%{% &showcmdloc == 'statusline' ? '%-10.S ' : '' %}
--- %{% exists('b:keymap_name') ? '<'..b:keymap_name..'> ' : '' %}
--- %{% &busy > 0 ? '◐ ' : '' %}
--- %(%{luaeval('(package.loaded[''vim.diagnostic''] and vim.diagnostic.status()) or '''' ')} %)
--- %{% &ruler ? ( &rulerformat == '' ? '%-14.(%l,%c%V%) %P' : &rulerformat ) : '' %}
local M = {}

--- LSP Document Symbol Breadcrumbs
---@type table<integer, string>
M.breadcrumbs = {}

local kind_map = {}
for k, v in pairs(vim.lsp.protocol.SymbolKind) do
  if type(k) == 'string' and type(v) == 'number' then kind_map[v] = k end
end

---@param path string[]
---@param symbol lsp.DocumentSymbol | lsp.SymbolInformation
local function append_chunk(path, symbol)
  local icon, icon_hl = MiniIcons.get('lsp', kind_map[symbol.kind])
  local chunk = ('%%#%s#%s %%#StatusLine#%s'):format(icon_hl, icon, symbol.name)
  table.insert(path, chunk)
end

---@param path string[]
---@param bufnr integer
---@param inner vim.Range
---@param symbols lsp.DocumentSymbol[]
---@return void
local function get_document_symbol_path(path, bufnr, inner, symbols)
  ---@type lsp.DocumentSymbol
  local symbol = vim.iter(symbols):find(function(s)
    local range = vim.range.lsp(bufnr, s.range, 'utf-8')
    return range:has(inner)
  end)
  if symbol == nil then return end
  append_chunk(path, symbol)
  if symbol.children ~= nil then get_document_symbol_path(path, bufnr, inner, symbol.children) end
end

---@param path string[]
---@param bufnr integer
---@param inner vim.Range
---@param symbols lsp.SymbolInformation[]
---@return void
local function get_symbol_information_path(path, bufnr, inner, symbols)
  for _, symbol in ipairs(symbols) do
    local range = vim.range.lsp(bufnr, symbol.location.range, 'utf-8')
    if range:has(inner) then append_chunk(path, symbol) end
  end
end

vim.api.nvim_create_autocmd({
  'CursorHold',
}, {
  desc = 'Lsp breadcrumbs',
  group = 'JPConfig',
  callback = function(args)
    local bufnr = args.buf
    local winnr = vim.api.nvim_get_current_win()
    local method = 'textDocument/documentSymbol'
    M.breadcrumbs[winnr] = nil
    local client = vim.lsp.get_clients({ bufnr = bufnr, method = method })[1]
    if client == nil then return end
    local chevron = require('icons').chevron.right

    local cursor = vim.api.nvim_win_get_cursor(winnr)
    local pos = vim.pos(cursor[1] - 1, cursor[2])
    local inner = vim.range(pos, pos)
    ---@type lsp.DocumentSymbolParams
    local params = {
      textDocument = vim.lsp.util.make_text_document_params(bufnr),
    }
    client:request(method, params, function(_err, result, _context, _config)
      local path = {}
      assert(_err == nil, _err)
      if result == nil then
      elseif vim.tbl_get(result, 1, 'range') ~= nil then
        get_document_symbol_path(path, bufnr, inner, result)
      else
        get_symbol_information_path(path, bufnr, inner, result)
      end
      local s = table.concat(path, chevron)
      if #s > 0 then s = chevron .. s end
      M.breadcrumbs[winnr] = s
      vim.cmd('redrawstatus')
    end, bufnr)
  end,
})

--- LSP Code Action Lightbulb
---@type integer
local code_action_count = 0
vim.api.nvim_create_autocmd({
  'CursorMoved',
}, {
  desc = 'Lsp code action lightbulb',
  group = 'JPConfig',
  callback = function(_args)
    code_action_count = 0
    vim.cmd('redrawstatus')
  end,
})
vim.api.nvim_create_autocmd({
  'CursorHold',
}, {
  desc = 'Lsp code action lightbulb',
  group = 'JPConfig',
  callback = function(args)
    local bufnr, winnr = args.buf, vim.api.nvim_get_current_win()

    local method = 'textDocument/codeAction'
    if #vim.lsp.get_clients({ bufnr = bufnr, method = method }) == 0 then return end
    local diagnostics = vim.lsp.diagnostic.from(vim.diagnostic.get(bufnr, {
      lnum = vim.api.nvim_win_get_cursor(winnr)[1] - 1,
    }))
    vim.lsp.buf_request_all(bufnr, method, function(client, _bufnr)
      local range = vim.lsp.util.make_range_params(winnr, client.offset_encoding)
      ---@type lsp.CodeActionParams
      return {
        textDocument = range.textDocument,
        range = range.range,
        context = {
          diagnostics = diagnostics,
          triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
        },
      }
    end, function(results, _context, _config)
      code_action_count = 0
      for _client_id, result in pairs(results) do
        if result.result ~= nil then
          ---@cast result.result (lsp.Command | lsp.CodeAction)[]
          code_action_count = code_action_count + #result.result
        end
      end
      vim.cmd('redrawstatus')
    end)
  end,
})

---@return string
function M.active()
  local winnr = vim.api.nvim_get_current_win()
  local filetype = vim.bo.filetype
  if _G.MiniIcons ~= nil and filetype ~= '' then
    local icon, icon_hl = MiniIcons.get('filetype', filetype)
    filetype = ('[%%#%s#%s %%#StatusLine#%s]'):format(icon_hl, icon, filetype)
  end
  local busy = vim.bo.busy > 0 and '󰦖 ' or ''
  local lightbulb = ''
  if code_action_count > 0 then lightbulb = ('󰌵 %s '):format(code_action_count) end
  return '%f%<'
    .. (M.breadcrumbs[winnr] or '')
    .. ' '
    .. filetype
    .. '%w%m%r %='
    .. busy
    .. lightbulb
    .. diagnostic()
    .. ruler
end

---@return string
function M.inactive()
  local filetype = vim.bo.filetype
  if _G.MiniIcons ~= nil and filetype ~= '' then
    local icon, _icon_hl = MiniIcons.get('filetype', filetype)
    filetype = ('[%s %s]'):format(icon, filetype)
  end
  local busy = vim.bo.busy > 0 and '󰦖 ' or ''
  return '%f%< ' .. filetype .. '%w%m%r %=' .. busy .. ruler
end

M.stl =
  [[%{%(nvim_get_current_win()==#g:actual_curwin || &laststatus==3) ? v:lua.require'statusline'.active() : v:lua.require'statusline'.inactive()%}]]

return M
