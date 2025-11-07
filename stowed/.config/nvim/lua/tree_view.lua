---@class treeView.Node<T>
---@field data T
---@field children treeView.Node<T>[]
---@field expanded boolean
---@field resolved boolean

---@alias treeView.Path integer[]

---@alias treeView.Chunk [string, string?]
---@alias treeView.Format<T> fun(data: T): treeView.Chunk[]
---@alias treeView.Hl [string, [integer, integer], [integer, integer]]

---@alias treeView.ExpandFn<T> fun(data: T): T[]
---@alias treeView.Action<T> fun(data: T)

---@class treeView.View<T>
---@field roots treeView.Node<T>[]
---@field format treeView.Format<T>
---@field expand_fn treeView.ExpandFn<T>
---@field action? treeView.Action<T>

local M = {}
local ns = vim.api.nvim_create_namespace('treeView')

---@generic T
---@param data T
---@return treeView.Node<T>
function M.to_node(data)
  return {
    data = data,
    children = {},
    expanded = false,
    resolved = false,
  }
end

---@generic T
---@param roots treeView.Node<T>[]
---@return treeView.Path[]
function M.tree_to_paths(roots)
  ---@type treeView.Path[]
  local acc = {}
  ---@param nodes treeView.Node<T>[]
  ---@param path treeView.Path
  function step(nodes, path)
    for i, node in ipairs(nodes) do
      local child_path = {}
      for _, n in ipairs(path) do
        child_path[#child_path + 1] = n
      end
      child_path[#child_path + 1] = i
      acc[#acc + 1] = child_path
      if node.expanded then step(node.children, child_path) end
    end
  end
  step(roots, {})
  return acc
end

---@generic T
---@param roots treeView.Node<T>[]
---@param path treeView.Path
---@return treeView.Node<T>
---@nodiscard
function M.get_path(roots, path)
  ---@type treeView.Node<T>
  local node
  local nodes = roots
  for _, n in ipairs(path) do
    node = assert(nodes[n], 'Failed to find node path')
    nodes = node.children
  end
  return node
end

---@generic T
---@param node treeView.Node<T>
---@param view treeView.View<T>
---@param expand boolean
function M.expand_node(node, view, expand)
  if expand then
    if not node.resolved then
      local child_data = view.expand_fn(node.data)
      node.children = {}
      for _, d in ipairs(child_data) do
        table.insert(node.children, M.to_node(d))
      end
      node.resolved = true
    end
    node.expanded = true
  else
    node.expanded = false
  end
end

---@generic T
---@param bufnr integer
---@param view treeView.View<T>
function M.keymap(bufnr, view)
  vim.keymap.set('n', '<Tab>', function()
    ---@generic T
    ---@type treeView.Node<T>[]
    local roots = view.roots
    local paths = M.tree_to_paths(roots)
    local pos = vim.api.nvim_win_get_cursor(0)
    local path = paths[pos[1]]

    assert(path ~= nil)
    local node = M.get_path(roots, path)

    M.expand_node(node, view, not node.expanded)
    M.render(bufnr, view)
  end, { buffer = bufnr })
  vim.keymap.set('n', '<CR>', function()
    ---@generic T
    ---@type treeView.Node<T>[]
    local roots = view.roots
    local paths = M.tree_to_paths(roots)
    local pos = vim.api.nvim_win_get_cursor(0)
    local path = paths[pos[1]]
    assert(path ~= nil)
    local node = M.get_path(roots, path)

    if view.action then
      view.action(node.data)
    else
      vim.notify('No action', vim.log.levels.WARN)
    end
  end, { buffer = bufnr })
end

---@generic T
---@param bufnr integer
---@param view treeView.View<T>
function M.render(bufnr, view)
  local roots = view.roots
  local format = view.format
  local paths = M.tree_to_paths(roots)
  ---@type string[]
  local replacement = {}
  ---@type treeView.Hl[]
  local hls = {}

  for line, path in ipairs(paths) do
    local node = M.get_path(roots, path)
    local chunks = format(node.data)
    local s = vim.fn['repeat']('  ', #path - 1)
      .. (
        (node.resolved and #node.children == 0 and ' ') or (node.expanded and ' ' or ' ')
      )

    for _, chunk in ipairs(chunks) do
      local text, hlgroup = unpack(chunk)

      if hlgroup then
        hls[#hls + 1] = {
          hlgroup,
          { line - 1, #s },
          { line - 1, #s + #text },
        }
      end
      s = s .. text
    end

    replacement[#replacement + 1] = s
  end

  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  vim.bo[bufnr].modifiable = true
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, replacement)
  vim.bo[bufnr].modifiable = false
  for _, hl in ipairs(hls) do
    vim.hl.range(bufnr, ns, unpack(hl))
  end
end

---@generic T
---@param view treeView.View<T>
function M.open(view)
  vim.cmd('12 split')
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, bufnr)
  vim.wo.winfixbuf = true
  vim.wo.winfixheight = true
  M.render(bufnr, view)
  M.keymap(bufnr, view)
end

return M
