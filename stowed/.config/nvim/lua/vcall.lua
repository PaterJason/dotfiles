local M = {}

--- Custom findfunc using ripgrep
---@param cmdarg string
---@param _cmdcomplete boolean
---@return string[]
function M.rg_ffu(cmdarg, _cmdcomplete)
  local fnames = vim.fn.systemlist('rg --files')
  if #cmdarg == 0 then
    return fnames
  else
    return vim.fn.matchfuzzy(fnames, cmdarg)
  end
end

local namespace = vim.api.nvim_create_namespace('pqf')

--- Custom quickfixtextfunc
---@param info {quickfix: 0|1, winid: integer, id: integer, start_idx: integer, end_idx: integer}
---@return string[]
function M.qftf(info)
  local what = { id = info.id, items = 1, qfbufnr = 1, winid = 1 }
  local list = (
    (info.quickfix == 1 and vim.fn.getqflist(what)) or vim.fn.getloclist(info.winid, what)
  )
  ---@type {
  --- bufnr: integer, module: string,
  --- lnum: integer, end_lnum: integer, col: integer, end_col:integer,
  --- text: string, type: string,
  --- vcol: 0|1, nr: integer, pattern: string, valid: 0|1, user_data: any
  --- }[]
  local items = list.items
  ---@type string[]
  local lines = {}
  ---@type [string, [integer, integer], [integer, integer]][]
  local highlights = {}

  local w = vim.w[list.winid]
  local qf_toc_title_regex = vim.regex([[\<TOC$\|\<Table of contents\>]])
  local is_toc = w.qf_toc
    or (
      w.quickfix_title
      and (
        qf_toc_title_regex:match_str(w.quickfix_title)
        or vim.startswith(w.quickfix_title, 'Symbols in ')
      )
    )

  for i = info.start_idx, info.end_idx do
    local item = items[i]
    assert(item ~= nil)
    local line = ''

    ---@type [string, string?][]
    local chunks = {}

    if item.valid == 1 and not is_toc then
      -- Type/Diagnostic
      if item.type ~= '' then
        local severity = vim.diagnostic.severity[(item.type):sub(1, 1):upper()]
        local hl_group = ({
          'DiagnosticSignError',
          'DiagnosticSignWarn',
          'DiagnosticSignInfo',
          'DiagnosticSignHint',
        })[severity]
        local type_string = item.type
        if item.nr > 0 then type_string = type_string .. '[' .. item.nr .. ']' end
        chunks[#chunks + 1] = { type_string, hl_group }
      end

      -- Module/Filename
      if #item.module ~= 0 then
        chunks[#chunks + 1] = { item.module, 'qfFileName' }
      elseif item.bufnr ~= 0 then
        local filename = vim.fn.expand(('#%s:~:.'):format(item.bufnr))
        if #filename ~= 0 then
          local icon, icon_hl = MiniIcons.get('file', filename)
          chunks[#chunks + 1] = { icon .. ' ' .. filename, icon_hl }
        else
          local icon, icon_hl = MiniIcons.get('default', 'file')
          chunks[#chunks + 1] = { icon .. ' ' .. '[No Name]', icon_hl }
        end
      end

      -- Position
      local pos_str = ''
      if item.lnum ~= 0 then pos_str = pos_str .. item.lnum end
      if item.end_lnum ~= 0 and item.end_lnum ~= item.lnum then
        pos_str = pos_str .. '-' .. item.end_lnum
      end
      if item.col ~= 0 then pos_str = pos_str .. ':' .. item.col end
      if item.end_col ~= 0 and item.end_col ~= item.col then
        pos_str = pos_str .. '-' .. item.end_col
      end
      if #pos_str ~= 0 then chunks[#chunks + 1] = { pos_str, 'qfLineNr' } end
    end

    -- Text
    if #item.text ~= 0 then chunks[#chunks + 1] = { item.text, 'qfText' } end

    ---@param s string
    ---@param hl_group string?
    local function append_line(s, hl_group)
      if hl_group ~= nil then
        highlights[#highlights + 1] = {
          hl_group,
          { i - 1, #line },
          { i - 1, #line + #s },
        }
      end
      line = line .. s
    end
    for idx, chunk in ipairs(chunks) do
      if idx > 1 then append_line('|', 'Delimiter') end
      append_line(unpack(chunk))
    end

    lines[#lines + 1] = line
  end

  -- Set highlights later, is there a less hacky way?
  vim.schedule(function()
    if info.start_idx == 1 then vim.api.nvim_buf_clear_namespace(list.qfbufnr, namespace, 0, -1) end
    for _, highlight in ipairs(highlights) do
      vim.hl.range(list.qfbufnr, namespace, unpack(highlight))
    end
  end)
  return lines
end

--- Custom statusline
--- Default:
--- %<%f %h%w%m%r %=%{% &showcmdloc == 'statusline' ? '%-10.S ' : '' %}
--- %{% exists('b:keymap_name') ? '<'..b:keymap_name..'> ' : '' %}
--- %{% &busy > 0 ? '◐ ' : '' %}
--- %(%{luaeval('(package.loaded[''vim.diagnostic''] and vim.diagnostic.status()) or '''' ')} %)
--- %{% &ruler ? ( &rulerformat == '' ? '%-14.(%l,%c%V%) %P' : &rulerformat ) : '' %}
---@return string
function M.stl()
  local filetype = vim.bo.filetype
  if _G.MiniIcons ~= nil and filetype ~= '' then
    local icon, icon_hl = MiniIcons.get('filetype', filetype)
    filetype = ('[%s %s]'):format(icon, filetype)
  end
  local dap = (package.loaded['dap'] and require('dap').status()) or ''
  if dap ~= '' then dap = ('[ %s]'):format(dap) end
  local busy = vim.bo.busy > 0 and '󰦖 ' or ''
  local diagnostic = (package.loaded['vim.diagnostic'] and vim.diagnostic.status() .. ' ') or ''
  local ruler = '%-14.(%l,%c%V%) %P'
  return '%f%< ' .. dap .. filetype .. '%w%m%r %=' .. busy .. diagnostic .. ruler
end

return M
