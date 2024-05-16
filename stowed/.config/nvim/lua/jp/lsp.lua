-- Diagnostics
vim.diagnostic.config({
  severity_sort = true,
  signs = false,
  float = {
    border = "single",
    header = "",
    source = true,
    title = "Diagnostics",
  },
})
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
vim.keymap.set("n", "<leader>Q", vim.diagnostic.setqflist, { desc = "Open diagnostics list" })

-- LSP
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

vim.keymap.set("n", "<leader>ti", function()
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
      methods.textDocument_documentSymbol,
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
    { methods.textDocument_references, "gr", vim.lsp.buf.references, "References" },
    { methods.textDocument_codeLens, "crl", vim.lsp.codelens.run, "Run code lens" },
    { methods.textDocument_rename, "crn", vim.lsp.buf.rename, "Rename" },
    { methods.textDocument_codeAction, "crr", vim.lsp.buf.code_action, "Code action" },
  }
  for _, value in ipairs(mappings) do
    local method, lhs, rhs, desc = unpack(value)
    if client.supports_method(method) then
      vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
    end
  end

  vim.keymap.set("n", "<leader>l", select, { buffer = bufnr, desc = "Select LSP call" })

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
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = attach,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = augroup,
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id) or {}

    vim.api.nvim_clear_autocmds({ group = attach_augroup, buffer = bufnr })
    vim.lsp.codelens.clear(client.id)
    vim.lsp.buf.clear_references()
  end,
})
