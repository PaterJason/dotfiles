local widgets = require('dap.ui.widgets')

local M = {}

---@alias dap_view.WidgetType
---|'sessions',
---|'scopes',
---|'frames',
---|'threads',

---@alias dap_view.Tab
---| 'repl'
---| dap_view.WidgetType

---@return integer?
---@nodiscard
function M.get_win()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.w[win].dap_view_tab ~= nil then return win end
  end
end

---@return integer
function M.mkwin()
  local win = M.get_win()
  if win ~= nil then
    vim.api.nvim_set_current_win(win)
  else
    vim.cmd('12 split')
    win = vim.api.nvim_get_current_win()
    vim.wo[win].number = false
    vim.wo[win].relativenumber = false
    vim.wo[win].winfixwidth = true
  end
  return win
end

---@type dap_view.Tab[]
M.tabs = {
  'repl',
  'sessions',
  'scopes',
  'frames',
  'threads',
}

function M.complete_tabs() return table.concat(M.tabs, '\n') end

---@type table<dap_view.WidgetType, table>
local widget_views = {}
for _, widget_type in ipairs({
  'sessions',
  'scopes',
  'frames',
  'threads',
}) do
  local widget = widgets[widget_type]
  local view = widgets
    .builder(widget)
    .new_win(M.mkwin)
    .new_buf(widgets.with_refresh(widget.new_buf, widget.refresh_listener or 'event_stopped'))
    .build()
  widget_views[widget_type] = view
end

---@param widget_type dap_view.WidgetType
---@return integer, integer
local function widget_open(widget_type)
  local view = widget_views[widget_type]
  view.open()
  view.refresh()
  return view.buf, view.win
end

---@param tab dap_view.Tab
function M.tab_open(tab)
  ---@type integer?, integer?
  local buf, win = nil, M.get_win()
  if win ~= nil then vim.wo[win].winfixbuf = false end

  ---@type table<dap_view.Tab, fun(): integer, integer>
  local fns = {
    --- @diagnostic disable-next-line: missing-return-value
    repl = function() return require('dap').repl.open({}, [[lua require'dap_view'.mkwin()]]) end,
    sessions = function() return widget_open('sessions') end,
    scopes = function() return widget_open('scopes') end,
    frames = function() return widget_open('frames') end,
    threads = function() return widget_open('threads') end,
  }
  buf, win = (fns[tab] or fns.repl)()

  vim.wo[win].winfixbuf = true
  vim.w[win].dap_view_tab = tab
  vim.wo[win].winbar = [[%{%v:lua.require'dap_view'.winbar()%}]]
  vim.api.nvim_create_autocmd('User', {
    desc = 'Redraw dap status',
    pattern = { 'DapProgressUpdate' },
    callback = function(_args) vim.api.nvim__redraw({ win = win, winbar = true }) end,
    group = vim.api.nvim_create_augroup('dap_view.winbar', { clear = true }),
  })
end

---@param i integer
function M.winbar_click(i)
  local tab = M.tabs[i]
  if tab ~= nil then M.tab_open(tab) end
end

function M.winbar()
  local winbar = '%#TabLineFill#'
  for i, tab in ipairs(M.tabs) do
    local hl = (vim.w.dap_view_tab == tab and 'TabLineSel') or 'TabLine'
    winbar = winbar
      .. ([[%%%d@v:lua.require'dap_view'.winbar_click@%%#%s# %s %%X]]):format(i, hl, tab)
  end
  winbar = winbar .. '%#TabLineFill#'
  local dap_status = require('dap').status()
  if dap_status ~= '' then winbar = winbar .. (' [ %s]'):format(dap_status) end
  return winbar
end

return M
