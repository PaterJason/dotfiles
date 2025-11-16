local tree_view = require('tree_view')
local M = {}

local kind_map = {}
for k, v in pairs(vim.lsp.protocol.SymbolKind) do
  if type(k) == 'string' and type(v) == 'number' then kind_map[v] = k end
end

---@alias hierarchyViewItem lsp.CallHierarchyItem | lsp.TypeHierarchyItem

---@param method
---| 'callHierarchy/incomingCalls'
---| 'callHierarchy/outgoingCalls'
---| 'typeHierarchy/subtypes'
---| 'typeHierarchy/supertypes'
function M.open(method)
  local bufnr, winnr = vim.api.nvim_get_current_buf(), vim.api.nvim_get_current_win()
  local prepare_method = (
    vim.list_contains({ 'callHierarchy/incomingCalls', 'callHierarchy/outgoingCalls' }, method)
    and 'textDocument/prepareCallHierarchy'
  ) or 'textDocument/prepareTypeHierarchy'
  local client = vim.lsp.get_clients({ bufnr = bufnr, method = prepare_method })[1]
  if client == nil then return end
  client:request(
    prepare_method,
    vim.lsp.util.make_position_params(0, client.offset_encoding),
    function(err, prepare_result, _context, _config)
      assert(err == nil, 'Error preparing hierarchy' .. vim.inspect(err))
      if prepare_result == nil then
        vim.notify('No hierarchy returned', vim.log.levels.WARN)
        return
      end
      ---@cast prepare_result hierarchyViewItem[]

      ---@type treeView.Node<hierarchyViewItem>[]
      local roots = {}
      for i, item in ipairs(prepare_result) do
        roots[i] = tree_view.to_node(item)
      end

      ---@type treeView.View<hierarchyViewItem>
      local view = {
        roots = roots,
        format = function(data)
          local name_hl = 'Normal'
          local _, kind_hl = MiniIcons.get('lsp', kind_map[data.kind])
          if data.tags then
            for _, tag in ipairs(data.tags) do
              if tag == 1 then name_hl = 'DiagnosticDeprecated' end
            end
          end
          local chunks = {
            { data.name, name_hl },
            { ('  [%s]'):format(vim.lsp.protocol.SymbolKind[data.kind]), kind_hl },
          }
          local detail = data.detail
          if detail ~= nil then
            chunks[#chunks + 1] = { ' ' .. detail:gsub('\n', ' '), 'Comment' }
          end
          return chunks
        end,
        expand_fn = function(data)
          local res, _ = client:request_sync(method, { item = data }, nil, bufnr)
          if res == nil then return {} end
          local expand_result = res.result
          if expand_result == nil then return {} end
          return vim
            .iter(expand_result)
            :map(function(item) return item.from or item.to or item end)
            :totable()
        end,
        action = function(data)
          ---@type lsp.Location
          local location = {
            uri = data.uri,
            range = data.selectionRange,
          }
          vim.api.nvim_set_current_win(winnr)
          vim.lsp.util.show_document(location, client.offset_encoding)
        end,
      }
      tree_view.open(view)
    end
  )
end

return M
