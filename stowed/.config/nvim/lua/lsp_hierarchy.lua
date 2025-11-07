local tree_view = require('tree_view')
local M = {}

local kind_map = {}
for k, v in pairs(vim.lsp.protocol.SymbolKind) do
  if type(k) == 'string' and type(v) == 'number' then kind_map[v] = k end
end

---@param method 'callHierarchy/incomingCalls' | 'callHierarchy/outgoingCalls'
function M.call_hierarchy(method)
  local bufnr = vim.api.nvim_get_current_buf()
  local winnr = vim.api.nvim_get_current_win()
  local prepare_method = 'textDocument/prepareCallHierarchy'
  local client = vim.lsp.get_clients({ bufnr = bufnr, method = prepare_method })[1]
  if client == nil then return end
  local offset_encoding = client.offset_encoding

  client:request(
    prepare_method,
    vim.lsp.util.make_position_params(0, offset_encoding),
    function(err, prepare_result, _context, _config)
      assert(err == nil, 'Error preparing call hierachy' .. vim.inspect(err))
      if prepare_result == nil then
        vim.notify('No call hierachy returned', vim.log.levels.WARN)
        return
      end
      ---@cast prepare_result lsp.CallHierarchyItem[]

      ---@type treeView.Node<lsp.CallHierarchyItem>[]
      local roots = {}
      for i, item in ipairs(prepare_result) do
        roots[i] = tree_view.to_node(item)
      end

      ---@type treeView.View<lsp.CallHierarchyItem>
      local view = {
        roots = roots,
        format = function(data)
          local item = data
          ---@cast item -?
          local name_hl = 'Normal'
          local _, kind_hl = MiniIcons.get('lsp', kind_map[item.kind])
          if item.tags then
            for _, tag in ipairs(item.tags) do
              if tag == 1 then name_hl = 'DiagnosticDeprecated' end
            end
          end
          local chunks = {
            { item.name, name_hl },
            { ('  [%s]'):format(vim.lsp.protocol.SymbolKind[item.kind]), kind_hl },
          }
          if item.detail ~= nil then
            chunks[#chunks + 1] = { ' ' .. item.detail:gsub('\n', ' '), 'Comment' }
          end
          return chunks
        end,
        expand_fn = function(data)
          local res, _ = client:request_sync(method, { item = data }, nil, bufnr)
          if res == nil then return {} end
          local expand_result = res.result
          if expand_result == nil then return {} end
          ---@cast expand_result (lsp.CallHierarchyIncomingCall | lsp.CallHierarchyOutgoingCall)[]
          ---@type lsp.CallHierarchyItem[]
          local children = {}
          for i, item in ipairs(expand_result) do
            children[i] = item.from or item.to
          end
          return children
        end,
        action = function(data)
          ---@type lsp.Location
          local location = {
            uri = data.uri,
            range = data.selectionRange,
          }
          vim.api.nvim_set_current_win(winnr)
          vim.lsp.util.show_document(location, offset_encoding)
        end,
      }
      tree_view.open(view)
    end
  )
end

return M
