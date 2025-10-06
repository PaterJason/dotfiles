local augroup = vim.api.nvim_create_augroup('JPConfigLsp', {})
local attach_augroup = vim.api.nvim_create_augroup('JPConfigLspAttach', {})

local function select()
  ---@type {text: string, on_choice: fun(), method: vim.lsp.protocol.Method}[]
  local items = {
    {
      text = 'Add workspace folder',
      on_choice = function() vim.lsp.buf.add_workspace_folder() end,
      method = 'workspace/didChangeWorkspaceFolders',
    },
    {
      text = 'Code action',
      on_choice = function() vim.lsp.buf.code_action() end,
      method = 'textDocument/codeAction',
    },
    {
      text = 'Declaration',
      on_choice = function() vim.lsp.buf.declaration() end,
      method = 'textDocument/declaration',
    },
    {
      text = 'Definition',
      on_choice = function() vim.lsp.buf.definition() end,
      method = 'textDocument/definition',
    },
    {
      text = 'Document symbol',
      on_choice = function() vim.lsp.buf.document_symbol() end,
      method = 'textDocument/documentSymbol',
    },
    {
      text = 'Format',
      on_choice = function() vim.lsp.buf.format() end,
      method = 'textDocument/formatting',
    },
    {
      text = 'Hover',
      on_choice = function() vim.lsp.buf.hover() end,
      method = 'textDocument/hover',
    },
    {
      text = 'Implementation',
      on_choice = function() vim.lsp.buf.implementation() end,
      method = 'textDocument/implementation',
    },
    {
      text = 'Incoming calls',
      on_choice = function() vim.lsp.buf.incoming_calls() end,
      method = 'textDocument/prepareCallHierarchy',
    },
    {
      text = 'List workspace folders',
      on_choice = function()
        local folders = vim.lsp.buf.list_workspace_folders()
        local msg = {
          { 'Workspace folders:\n', 'Normal' },
          { table.concat(folders, '\n'), 'Normal' },
        }
        vim.api.nvim_echo(msg, true, {})
      end,
      method = 'workspace/workspaceFolders',
    },
    {
      text = 'Outgoing calls',
      on_choice = function() vim.lsp.buf.outgoing_calls() end,
      method = 'textDocument/prepareCallHierarchy',
    },
    {
      text = 'References',
      on_choice = function() vim.lsp.buf.references() end,
      method = 'textDocument/references',
    },
    {
      text = 'Remove workspace folder',
      on_choice = function() vim.lsp.buf.remove_workspace_folder() end,
      method = 'workspace/didChangeWorkspaceFolders',
    },
    {
      text = 'Rename',
      on_choice = function() vim.lsp.buf.rename() end,
      method = 'textDocument/rename',
    },
    {
      text = 'Signature help',
      on_choice = function() vim.lsp.buf.signature_help() end,
      method = 'textDocument/signatureHelp',
    },
    {
      text = 'Type definition',
      on_choice = function() vim.lsp.buf.type_definition() end,
      method = 'textDocument/typeDefinition',
    },
    {
      text = 'Subtypes',
      on_choice = function() vim.lsp.buf.typehierarchy('subtypes') end,
      method = 'textDocument/prepareTypeHierarchy',
    },
    {
      text = 'Supertypes',
      on_choice = function() vim.lsp.buf.typehierarchy('supertypes') end,
      method = 'textDocument/prepareTypeHierarchy',
    },
    {
      text = 'Workspace symbol',
      on_choice = function() vim.lsp.buf.workspace_symbol() end,
      method = 'workspace/symbol',
    },
    {
      text = 'Run code lens',
      on_choice = function() vim.lsp.codelens.run() end,
      method = 'textDocument/codeLens',
    },
    {
      text = 'Toggle inlay hints',
      on_choice = function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end,
      method = 'textDocument/inlayHint',
    },
    {
      text = 'Toggle inline completion',
      on_choice = function()
        vim.lsp.inline_completion.enable(not vim.lsp.inline_completion.is_enabled())
      end,
      method = 'textDocument/inlineCompletion',
    },
    {
      text = 'Colour presentation selection',
      on_choice = function() vim.lsp.document_color.color_presentation() end,
      method = 'textDocument/documentColor',
    },
    {
      text = 'Linked editing range on',
      on_choice = function() vim.lsp.linked_editing_range.enable(true) end,
      method = 'textDocument/linkedEditingRange',
    },
    {
      text = 'Linked editing range off',
      on_choice = function() vim.lsp.linked_editing_range.enable(false) end,
      method = 'textDocument/linkedEditingRange',
    },
  }

  items = vim.tbl_filter(
    function(item)
      return not vim.tbl_isempty(vim.lsp.get_clients({
        bufnr = 0,
        method = item.method,
      }))
    end,
    items
  )

  vim.ui.select(items, {
    format_item = function(item) return item.text end,
    prompt = 'LSP',
  }, function(item)
    if item then item.on_choice() end
  end)
end

-- Keymaps
vim.keymap.set('n', '<Leader>l', function() select() end, { desc = 'Select LSP call' })
vim.keymap.set('n', 'grl', function() vim.lsp.codelens.run() end, {
  desc = 'vim.lsp.codelens.run()',
})
vim.keymap.set({ 'n', 'x' }, 'grf', function() vim.lsp.buf.format() end, {
  desc = 'vim.lsp.buf.format()',
})
vim.keymap.set('n', '<Leader>ti', function()
  local is_enabled = vim.lsp.inlay_hint.is_enabled({})
  vim.lsp.inlay_hint.enable(not is_enabled)
  vim.notify('Inlay hints ' .. (is_enabled and 'disabled' or 'enabled'))
end, { desc = 'Toggle inlay hints' })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    local bufnr = args.buf
    ---@param method vim.lsp.protocol.Method.ClientToServer
    ---@return boolean
    ---@nodiscard
    local function supports_method(method) return client:supports_method(method, bufnr) end
    if supports_method('textDocument/documentHighlight') then
      vim.api.nvim_create_autocmd('CursorHold', {
        callback = function(_args)
          vim.lsp.buf.clear_references()
          vim.lsp.buf.document_highlight()
        end,
        group = attach_augroup,
        buffer = bufnr,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'ModeChanged', 'BufLeave' }, {
        callback = function(_args) vim.lsp.buf.clear_references() end,
        group = attach_augroup,
        buffer = bufnr,
      })
    end
    if supports_method('textDocument/codeLens') then
      vim.api.nvim_create_autocmd({ 'BufEnter', 'TextChanged', 'InsertLeave' }, {
        callback = function(_args) vim.lsp.codelens.refresh({ bufnr = bufnr }) end,
        group = attach_augroup,
        buffer = bufnr,
      })
      vim.lsp.codelens.refresh({ bufnr = bufnr })
    end
    if supports_method('textDocument/hover') then
      vim.keymap.set(
        'n',
        'K',
        function() vim.lsp.buf.hover() end,
        { buffer = bufnr, desc = 'Hover' }
      )
    end
    if supports_method('textDocument/foldingRange') then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end
  end,
  group = augroup,
})

vim.api.nvim_create_autocmd('LspDetach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    vim.api.nvim_clear_autocmds({ group = attach_augroup, buffer = bufnr })
    vim.lsp.codelens.clear(client.id)
    vim.lsp.buf.clear_references()
  end,
  group = augroup,
})

---@type { [lsp.ProgressToken]: (integer|string) }
local progress_tokens = {}
vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    ---@type lsp.ProgressParams
    local params = ev.data.params
    ---@diagnostic disable-next-line: assign-type-mismatch
    ---@type lsp.WorkDoneProgressBegin | lsp.WorkDoneProgressEnd | lsp.WorkDoneProgressReport
    local value = params.value
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    assert(client ~= nil, 'No LSP client found')
    local message = value.message
    local chunks = (message ~= nil and { { vim.trim(message) } }) or {}
    local history = value.kind ~= 'report'
    local title = string.format(
      '[LSP][%s] %s',
      client.name,
      value.title or client.progress.pending[params.token]
    )
    local status = (value.kind == 'end' and 'success') or 'running'
    progress_tokens[params.token] = vim.api.nvim_echo(chunks, history, {
      id = progress_tokens[params.token],
      kind = 'progress',
      title = title,
      status = status,
      percent = value.percentage,
    })
    if value.kind == 'end' then progress_tokens[params.token] = nil end
  end,
})
