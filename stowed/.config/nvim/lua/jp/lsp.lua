vim.diagnostic.config {
  severity_sort = true,
  signs = false,
  float = {
    border = "single",
    header = "",
    source = true,
    title = "Diagnostics",
  },
}
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
vim.keymap.set("n", "<leader>Q", vim.diagnostic.setqflist, { desc = "Open diagnostics list" })

local methods = vim.lsp.protocol.Methods
local handlers = vim.lsp.handlers

handlers[methods.textDocument_hover] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
  title = "Hover",
})
handlers[methods.textDocument_signatureHelp] = vim.lsp.with(vim.lsp.handlers.signature_help, {
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
    -- {
    --   text = "Clear references",
    --   on_choice = vim.lsp.buf.clear_references,
    --   method = methods.textDocument_documentHighlight,
    -- },
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
    -- {
    --   text = "Document highlight",
    --   on_choice = vim.lsp.buf.document_highlight,
    --   method = methods.textDocument_documentHighlight,
    -- },
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
        vim.notify("Workspace folders: " .. table.concat(vim.lsp.buf.list_workspace_folders(), ", "))
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
      text = "Workspace symbol",
      on_choice = vim.lsp.buf.workspace_symbol,
      method = methods.workspace_symbol,
    },
    {
      text = "Toggle inlay hints",
      on_choice = function()
        vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
      end,
      method = methods.textDocument_inlayHint,
    },
  }

  items = vim.tbl_filter(function(item)
    return not vim.tbl_isempty(vim.lsp.get_clients {
      bufnr = 0,
      method = item.method,
    })
  end, items)

  vim.ui.select(items, {
    format_item = function(item)
      return item.text
    end,
    prompt = "LSP",
  }, function(choice)
    if choice then
      choice.on_choice()
    end
  end)
end

local function attach(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  ---@cast client -?
  local bufnr = args.buf

  -- Keymaps
  local mappings = {
    { methods.textDocument_declaration, "gD", vim.lsp.buf.declaration, "Jump to declaration" },
    { methods.textDocument_definition, "gd", vim.lsp.buf.definition, "Jump to definition" },
    { methods.textDocument_hover, "K", vim.lsp.buf.hover, "Hover" },
    { methods.textDocument_implementation, "gI", vim.lsp.buf.implementation, "Implementations" },
    { methods.textDocument_signatureHelp, "<C-k>", vim.lsp.buf.signature_help, "Signature Help" },
    { methods.workspace_workspaceFolders, "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add Workspace Folder" },
    {
      methods.workspace_workspaceFolders,
      "<leader>wr",
      vim.lsp.buf.remove_workspace_folder,
      "Remove Workspace Folder",
    },
    {
      methods.workspace_workspaceFolders,
      "<leader>wl",
      function()
        vim.notify(table.concat(vim.lsp.buf.list_workspace_folders(), ", "))
      end,
      "List Workspace Folders",
    },
    { methods.textDocument_definition, "<leader>D", vim.lsp.buf.type_definition, "Type Definition" },
    { methods.textDocument_rename, "<leader>rn", vim.lsp.buf.rename, "Rename" },
    { methods.textDocument_codeAction, "<leader>ca", vim.lsp.buf.code_action, "Code Action" },
    { methods.callHierarchy_incomingCalls, "<leader>ci", vim.lsp.buf.incoming_calls, "Incoming calls" },
    { methods.callHierarchy_outgoingCalls, "<leader>co", vim.lsp.buf.outgoing_calls, "Outgoing calls" },
    { methods.textDocument_references, "gr", vim.lsp.buf.references, "List References" },

    { methods.workspace_symbol, "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace Symbols" },
    { methods.textDocument_documentSymbol, "gO", vim.lsp.buf.document_symbol, "Document Symbols" },
    {
      methods.textDocument_inlayHint,
      "<leader>ti",
      function()
        vim.lsp.inlay_hint.enable(bufnr, not vim.lsp.inlay_hint.is_enabled(bufnr))
      end,
      "Toggle Inlay Hints",
    },
  }
  for _, value in ipairs(mappings) do
    local method, lhs, rhs, desc = unpack(value)
    if client.supports_method(method) then
      vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
    end
  end

  vim.keymap.set("n", "<leader>l", select, { buffer = bufnr, desc = "Select LSP call" })

  -- Autocommands
  vim.api.nvim_clear_autocmds { group = attach_augroup, buffer = bufnr }
  if client.supports_method(methods.textDocument_documentHighlight) then
    vim.api.nvim_create_autocmd(
      "CursorHold",
      { callback = vim.lsp.buf.document_highlight, group = attach_augroup, buffer = bufnr }
    )
    vim.api.nvim_create_autocmd(
      { "CursorMoved", "ModeChanged", "BufLeave" },
      { callback = vim.lsp.buf.clear_references, group = attach_augroup, buffer = bufnr }
    )
  end
  if client.supports_method(methods.textDocument_codeLens) then
    vim.api.nvim_create_autocmd(
      { "BufEnter", "TextChanged", "InsertLeave" },
      { callback = vim.lsp.codelens.refresh, group = attach_augroup, buffer = bufnr }
    )
    vim.lsp.codelens.refresh()
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

    vim.api.nvim_clear_autocmds { group = attach_augroup, buffer = bufnr }
    vim.lsp.codelens.clear(client.id)
    vim.lsp.buf.clear_references()
  end,
})
