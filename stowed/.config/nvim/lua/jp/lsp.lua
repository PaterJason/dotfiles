local methods = vim.lsp.protocol.Methods

local augroup = vim.api.nvim_create_augroup("JPConfigLsp", {})
local attach_augroup = vim.api.nvim_create_augroup("JPConfigLspAttach", {})
local documentColor_ns = vim.api.nvim_create_namespace("lsp.documentColor")

local function select()
  ---@type {text: string, on_choice: fun(), method: string}[]
  local items = {
    {
      text = "Add workspace folder",
      on_choice = vim.lsp.buf.add_workspace_folder,
      method = methods.workspace_workspaceFolders,
    },
    {
      text = "Code action",
      on_choice = vim.lsp.buf.code_action,
      method = methods.textDocument_codeAction,
    },
    {
      text = "Declaration",
      on_choice = vim.lsp.buf.declaration,
      method = methods.textDocument_declaration,
    },
    {
      text = "Definition",
      on_choice = vim.lsp.buf.definition,
      method = methods.textDocument_definition,
    },
    {
      text = "Document symbol",
      on_choice = vim.lsp.buf.document_symbol,
      method = methods.textDocument_documentSymbol,
    },
    {
      text = "Format",
      on_choice = vim.lsp.buf.format,
      method = methods.textDocument_formatting,
    },
    {
      text = "Hover",
      on_choice = vim.lsp.buf.hover,
      method = methods.textDocument_hover,
    },
    {
      text = "Implementation",
      on_choice = vim.lsp.buf.implementation,
      method = methods.textDocument_implementation,
    },
    {
      text = "Incoming calls",
      on_choice = vim.lsp.buf.incoming_calls,
      method = methods.callHierarchy_incomingCalls,
    },
    {
      text = "List workspace folders",
      on_choice = function()
        local folders = vim.lsp.buf.list_workspace_folders()
        local msg = {
          { "Workspace folders:\n", "Normal" },
          { table.concat(folders, "\n"), "Normal" },
        }
        vim.api.nvim_echo(msg, true, {})
      end,
      method = methods.workspace_workspaceFolders,
    },
    {
      text = "Outgoing calls",
      on_choice = vim.lsp.buf.outgoing_calls,
      method = methods.callHierarchy_outgoingCalls,
    },
    {
      text = "References",
      on_choice = vim.lsp.buf.references,
      method = methods.textDocument_references,
    },
    {
      text = "Remove workspace folder",
      on_choice = vim.lsp.buf.remove_workspace_folder,
      method = methods.workspace_workspaceFolders,
    },
    {
      text = "Rename",
      on_choice = vim.lsp.buf.rename,
      method = methods.textDocument_rename,
    },
    {
      text = "Signature help",
      on_choice = vim.lsp.buf.signature_help,
      method = methods.textDocument_signatureHelp,
    },
    {
      text = "Type definition",
      on_choice = vim.lsp.buf.type_definition,
      method = methods.textDocument_typeDefinition,
    },
    {
      text = "Type hierarchy",
      on_choice = vim.lsp.buf.typehierarchy,
      method = methods.textDocument_prepareTypeHierarchy,
    },
    {
      text = "Workspace symbol",
      on_choice = vim.lsp.buf.workspace_symbol,
      method = methods.workspace_symbol,
    },
    {
      text = "Run code lens",
      on_choice = function() vim.lsp.codelens.run() end,
      method = methods.textDocument_codeLens,
    },
    {
      text = "Toggle inlay hints",
      on_choice = function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end,
      method = methods.textDocument_inlayHint,
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
    prompt = "LSP",
  }, function(item)
    if item then item.on_choice() end
  end)
end

vim.keymap.set("n", "<Leader>ti", function()
  local is_enabled = vim.lsp.inlay_hint.is_enabled({})
  vim.lsp.inlay_hint.enable(not is_enabled)
  vim.notify("Inlay hints " .. (is_enabled and "disabled" or "enabled"))
end, { desc = "Toggle inlay hints" })

---@type fun(args: vim.api.keyset.create_autocmd.callback_args):boolean?
local function attach(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if not client then return end
  local bufnr = args.buf
  local function supports_method(method) return client:supports_method(method, bufnr) end
  if supports_method(methods.textDocument_documentHighlight) then
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function(_args)
        vim.lsp.buf.clear_references()
        vim.lsp.buf.document_highlight()
      end,
      group = attach_augroup,
      buffer = bufnr,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "ModeChanged", "BufLeave" }, {
      callback = function(_args) vim.lsp.buf.clear_references() end,
      group = attach_augroup,
      buffer = bufnr,
    })
  end
  if supports_method(methods.textDocument_codeLens) then
    vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "InsertLeave" }, {
      callback = function(_args) vim.lsp.codelens.refresh({ bufnr = bufnr }) end,
      group = attach_augroup,
      buffer = bufnr,
    })
    vim.lsp.codelens.refresh({ bufnr = bufnr })
  end
  if supports_method(methods.textDocument_documentColor) then
    local function update()
      client:request(
        methods.textDocument_documentColor,
        { textDocument = vim.lsp.util.make_text_document_params(bufnr) },
        function(err, result, _context)
          vim.api.nvim_buf_clear_namespace(bufnr, documentColor_ns, 0, -1)
          if err then return end
          ---@cast result lsp.ColorInformation[]
          for _, ci in ipairs(result) do
            local hex = ("#%02x%02x%02x"):format(
              math.floor(ci.color.red * 255 + 0.5),
              math.floor(ci.color.green * 255 + 0.5),
              math.floor(ci.color.blue * 255 + 0.5)
            )
            local hl_group = MiniHipatterns.compute_hex_color_group(hex, "bg")
            vim.api.nvim_buf_set_extmark(
              bufnr,
              documentColor_ns,
              ci.range.start.line,
              ci.range.start.character,
              {
                end_row = ci.range["end"].line,
                end_col = ci.range["end"].character,
                hl_group = hl_group,
              }
            )
          end
        end,
        bufnr
      )
    end
    vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "InsertLeave" }, {
      callback = function(_args) update() end,
      group = attach_augroup,
      buffer = bufnr,
    })
    update()
  end

  -- Keymaps
  if supports_method(methods.textDocument_hover) then
    vim.keymap.set(
      "n",
      "K",
      function()
        vim.lsp.buf.hover({
          border = "single",
          title = ("Hover: %s"):format(client.name),
          title_pos = "left",
        })
      end,
      { buffer = bufnr, desc = "Hover" }
    )
  end
  if supports_method(methods.textDocument_signatureHelp) then
    vim.keymap.set(
      "i",
      "<C-S>",
      function()
        vim.lsp.buf.signature_help({
          border = "single",
          title = "Signature help",
          title_pos = "left",
        })
      end,
      { desc = "Signature help" }
    )
    vim.keymap.set(
      "n",
      "grs",
      function()
        vim.lsp.buf.signature_help({
          border = "single",
          title = "Signature help",
          title_pos = "left",
        })
      end,
      { desc = "Signature help" }
    )
  end
  if supports_method(methods.textDocument_codeLens) then
    vim.keymap.set("n", "grl", vim.lsp.codelens.run, { buffer = bufnr, desc = "Run code lens" })
  end
  vim.keymap.set("n", "<Leader>l", select, { buffer = bufnr, desc = "Select LSP call" })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = attach,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = augroup,
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    vim.api.nvim_clear_autocmds({ group = attach_augroup, buffer = bufnr })
    vim.lsp.codelens.clear(client.id)
    vim.lsp.buf.clear_references()
    vim.api.nvim_buf_clear_namespace(bufnr, documentColor_ns, 0, -1)
  end,
})

for filename in vim.fs.dir(vim.fn.stdpath("config") .. "/lsp", {}) do
  local name = filename:gsub("%.lua$", "")
  vim.lsp.enable(name)
end
