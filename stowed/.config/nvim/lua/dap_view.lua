local widgets = require('dap.ui.widgets')

local M = {}

---@alias dap.WidgetType
---|'sessions',
---|'scopes',
---|'frames',
---|'threads',

---@type dap.WidgetType[]
M.tabs = {
  'sessions',
  'scopes',
  'frames',
  'threads',
}

local function dap_widget_mkwin()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.w[win].dapwidget ~= nil then return win end
  end

  local prevwin = vim.api.nvim_get_current_win()
  vim.cmd('50 vsplit')
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(prevwin)
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].winfixwidth = true
  return win
end

M.views = {}
for _, widget_type in ipairs(M.tabs) do
  local widget = widgets[widget_type]
  local view = widgets
    .builder(widget)
    .new_win(dap_widget_mkwin)
    .new_buf(widgets.with_refresh(widget.new_buf, widget.refresh_listener or 'event_stopped'))
    .build()
  M.views[widget_type] = view
end

---@param i integer
function M.winbar_click(i)
  local widget_type = M.tabs[i]
  if widget_type ~= nil then M.dap_widget(widget_type) end
end

function M.winbar()
  local winbar = '%#TabLineFill#'
  local widget_type = vim.w.dapwidget
  for i, tab in ipairs(M.tabs) do
    local hl = (widget_type == tab and 'TabLineSel') or 'TabLine'
    winbar = winbar
      .. ([[%%%d@v:lua.require'dap_view'.winbar_click@%%#%s# %s %%X]]):format(i, hl, tab)
  end
  winbar = winbar .. '%#TabLineFill#'
  return winbar
end

---@param widget_type dap.WidgetType
function M.dap_widget(widget_type)
  local view = M.views[widget_type]
  view.open()
  view.refresh()
  vim.wo[view.win].winbar = [[%{%v:lua.require'dap_view'.winbar()%}]]
  vim.w[view.win].dapwidget = widget_type
  return view
end

return M
