vim.diagnostic.config {
  severity_sort = true,
  signs = false,
}

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

local augroup = vim.api.nvim_create_augroup("JPConfigLsp", {})
local attach_augroup = vim.api.nvim_create_augroup("JPConfigLspAttach", {})

local function attach(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  ---@cast client -?
  local bufnr = args.buf
  local methods = vim.lsp.protocol.Methods

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
    { methods.textDocument_formatting, "<leader>f", vim.lsp.buf.format, "Format" },

    { methods.workspace_symbol, "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace Symbols" },
    { methods.textDocument_documentSymbol, "gO", vim.lsp.buf.document_symbol, "Document Symbols" },
    {
      methods.textDocument_inlayHint,
      "<leader>ti",
      function()
        vim.lsp.inlay_hint(bufnr, nil)
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
