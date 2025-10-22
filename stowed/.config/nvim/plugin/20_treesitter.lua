---@type { index: integer, nodes: TSNode[] }?
local selection_nodes = nil

---@param node TSNode
local function select_node(node)
  local start_row, start_col, end_row, end_col = node:range()

  -- If the selection ends at column 0, adjust the position to the end of the previous line.
  if end_col == 0 then
    end_row = end_row - 1
    end_col = #vim.api.nvim_buf_get_lines(0, end_row, end_row + 1, true)[1]
  end

  vim.fn.setpos("'<", { 0, start_row + 1, start_col + 1, 0 })
  vim.fn.setpos("'>", { 0, end_row + 1, end_col, 0 })
  vim.cmd.normal({ 'gv', bang = true })
end

--- @param direction 'inner' | 'outer'
local function selection_range(direction)
  if selection_nodes ~= nil then
    local offset = direction == 'outer' and -1 or 1
    local new_index = selection_nodes.index + offset
    if new_index <= #selection_nodes.nodes and new_index >= 1 then
      selection_nodes.index = new_index
    end
    select_node(selection_nodes.nodes[selection_nodes.index] --[[@cast -?]])
    return
  end

  local pos_node = vim.treesitter.get_node({})
  if pos_node == nil then return end
  ---@type TSNode?
  local node = pos_node:tree():root()
  ---@type TSNode[]
  local nodes = { node }
  while node ~= nil do
    local next_node = node:child_with_descendant(pos_node)
    if next_node ~= nil and not vim.deep_equal({ next_node:range() }, { node:range() }) then
      nodes[#nodes + 1] = next_node
    end
    node = next_node
  end

  if #nodes == 0 then return end
  ---@type TSNode[]
  selection_nodes = {
    index = #nodes,
    nodes = nodes,
  }
  select_node(nodes[#nodes] --[[@cast -?]])

  -- Clear selection ranges when leaving visual mode.
  vim.api.nvim_create_autocmd('ModeChanged', {
    pattern = 'v*:*',
    callback = function() selection_nodes = nil end,
    group = 'JPConfig',
    once = true,
  })
end

vim.keymap.set(
  'x',
  'am',
  function() selection_range('outer') end,
  { desc = 'Treesitter selection_range (outer)' }
)

vim.keymap.set(
  'x',
  'im',
  function() selection_range('inner') end,
  { desc = 'Treesitter selection_range (inner)' }
)

local namespace = vim.api.nvim_create_namespace('treesitter.diagnostic')

--- @param bufnr integer
local function lint(bufnr)
  local query = vim.treesitter.query.parse('lua', '[(ERROR)(MISSING)] @tslint')
  if vim.bo[bufnr].buftype ~= '' then return end
  local parser = assert(vim.treesitter.get_parser(bufnr, nil, {}))
  parser:parse()
  --- @type vim.Diagnostic[]
  local diagnostics = {}
  parser:for_each_tree(function(tree, ltree)
    local lang = ltree:lang()
    if vim.list_contains({ 'comment' }, lang) then return end
    for _id, node, metadata, _match in query:iter_captures(tree:root(), bufnr) do
      local range = vim.treesitter.get_range(node, 0, metadata)
      local message = node:missing() and 'Missing ' .. node:type()
        or 'Syntax error: ' .. vim.treesitter.get_node_text(node, bufnr):gsub('\n', ' ')
      diagnostics[#diagnostics + 1] = {
        bufnr = bufnr,
        namespace = namespace,
        lnum = range[1],
        col = range[2],
        end_lnum = range[4],
        end_col = range[5],
        severity = vim.diagnostic.severity.ERROR,
        message = message,
        source = ('TS[%s]'):format(lang),
      }
    end
  end)
  vim.diagnostic.set(namespace, bufnr, diagnostics, {})
end

vim.api.nvim_create_user_command(
  'TSLint',
  function(_args) lint(vim.api.nvim_get_current_buf()) end,
  {}
)
vim.api.nvim_create_user_command('TSLintReset', function(_args) vim.diagnostic.reset(namespace) end, {})
