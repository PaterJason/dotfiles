if
  vim.w.quickfix_title
  and (
    vim.w.quickfix_title == "Table of contents"
    or vim.startswith(vim.w.quickfix_title, "Symbols in ")
  )
then
  vim.wo.concealcursor = "nc"
  vim.wo.conceallevel = 3
  vim.cmd([[syn match Ignore "^[^|]*|[^|]*| " conceal]])
end
