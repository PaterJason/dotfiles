if
  vim.w.quickfix_title and vim.startswith(vim.w.quickfix_title, "Symbols in ")
  -- vim.tbl_get(vim.fn.getloclist(0, { context = 1 }), "context", "method")
  -- == vim.lsp.protocol.Methods.textDocument_documentSymbol
then
  vim.wo.concealcursor = "nc"
  vim.wo.conceallevel = 3
  vim.cmd([[syn match Ignore "^[^|]*|[^|]*| " conceal]])
end
