local methods = vim.lsp.protocol.Methods
local handlers = vim.lsp.handlers

handlers[methods.textDocument_hover] = vim.lsp.with(handlers.hover, {
  border = "single",
  title = "Hover",
})
handlers[methods.textDocument_signatureHelp] = vim.lsp.with(handlers.signature_help, {
  border = "single",
  title = "Signature help",
})

local augroup = vim.api.nvim_create_augroup("JPConfigLsp", {})
local attach_augroup = vim.api.nvim_create_augroup("JPConfigLspAttach", {})

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
        vim.notify(
          #folders == 0 and "No workspace folders"
            or "Workspace folders:\n" .. table.concat(folders, "\n")
        )
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
      text = "Type hierarchy",
      on_choice = vim.lsp.buf.typehierarchy,
      method = methods.textDocument_prepareTypeHierarchy,
    },
    {
      text = "Type definition",
      on_choice = vim.lsp.buf.type_definition,
      method = methods.textDocument_typeDefinition,
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
  }, function(choice)
    if choice then choice.on_choice() end
  end)
end

vim.keymap.set("n", "<Leader>ti", function()
  local is_enabled = vim.lsp.inlay_hint.is_enabled({})
  vim.lsp.inlay_hint.enable(not is_enabled)
  vim.notify("Inlay hints " .. (is_enabled and "disabled" or "enabled"))
end, { desc = "Toggle inlay hints" })

local function attach(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  ---@cast client -?
  local bufnr = args.buf
  local file = args.file

  -- Keymaps
  local mappings = {
    {
      methods.textDocument_hover,
      "n",
      "K",
      vim.lsp.buf.hover,
      "Hover",
    },
    {
      methods.textDocument_documentSymbol,
      "n",
      "gO",
      function()
        vim.lsp.buf.document_symbol({
          on_list = function(options)
            options.title = options.title .. " TOC"
            vim.fn.setloclist(0, {}, " ", options)
            vim.cmd("lopen")
            vim.w.qf_toc = file
          end,
        })
      end,
      "Document symbols",
    },
    {
      methods.textDocument_references,
      "n",
      "grr",
      vim.lsp.buf.references,
      "References",
    },
    {
      methods.textDocument_codeLens,
      "n",
      "grl",
      vim.lsp.codelens.run,
      "Run code lens",
    },
    {
      methods.textDocument_rename,
      "n",
      "grn",
      vim.lsp.buf.rename,
      "Rename",
    },
    {
      methods.textDocument_codeAction,
      { "n", "v" },
      "gra",
      vim.lsp.buf.code_action,
      "Code action",
    },
    {
      methods.textDocument_signatureHelp,
      "i",
      "<C-s>",
      vim.lsp.buf.signature_help,
      "Signature help",
    },
  }
  for _, value in ipairs(mappings) do
    local method, mode, lhs, rhs, desc = unpack(value)
    if client.supports_method(method) then
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end
  end

  vim.keymap.set("n", "<Leader>l", select, { buffer = bufnr, desc = "Select LSP call" })

  -- Autocommands
  vim.api.nvim_clear_autocmds({ group = attach_augroup, buffer = bufnr })
  if client.supports_method(methods.textDocument_documentHighlight) then
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.lsp.buf.clear_references()
        vim.lsp.buf.document_highlight()
      end,
      group = attach_augroup,
      buffer = bufnr,
    })
    vim.api.nvim_create_autocmd(
      { "CursorMoved", "ModeChanged", "BufLeave" },
      { callback = vim.lsp.buf.clear_references, group = attach_augroup, buffer = bufnr }
    )
  end
  if client.supports_method(methods.textDocument_codeLens) then
    vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "InsertLeave" }, {
      callback = function() vim.lsp.codelens.refresh({ bufnr = bufnr }) end,
      group = attach_augroup,
      buffer = bufnr,
    })
    vim.lsp.codelens.refresh({ bufnr = bufnr })
  end

  if client.supports_method(methods.textDocument_documentColor) then
    local ns = vim.api.nvim_create_namespace("lsp.documentColor")
    local function update()
      client.request(
        methods.textDocument_documentColor,
        { textDocument = vim.lsp.util.make_text_document_params(bufnr) },
        function(err, result, context, config)
          vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
          if err then return end
          ---@cast result lsp.ColorInformation[]
          for _, ci in ipairs(result) do
            local hex = string.format(
              "#%02x%02x%02x",
              math.floor(ci.color.red * 255 + 0.5),
              math.floor(ci.color.green * 255 + 0.5),
              math.floor(ci.color.blue * 255 + 0.5)
            )
            local hl_group = MiniHipatterns.compute_hex_color_group(hex, "bg")
            vim.api.nvim_buf_set_extmark(bufnr, ns, ci.range.start.line, ci.range.start.character, {
              end_row = ci.range["end"].line,
              end_col = ci.range["end"].character,
              hl_group = hl_group,
            })
          end
        end,
        bufnr
      )
    end
    vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "InsertLeave" }, {
      callback = update,
      group = attach_augroup,
      buffer = bufnr,
    })
    update()
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = attach,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = augroup,
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id) or {}

    vim.api.nvim_clear_autocmds({ group = attach_augroup, buffer = bufnr })
    vim.lsp.codelens.clear(client.id)
    vim.lsp.buf.clear_references()
    vim.api.nvim_buf_clear_namespace(bufnr, ns_documentColor, 0, -1)
  end,
})
