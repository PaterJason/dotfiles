local completion = require'completion'

vim.cmd("autocmd BufEnter * lua require'completion'.on_attach()")

vim.g.diagnostic_enable_virtual_text = 1
vim.g.diagnostic_auto_popup_while_jump = 0

vim.g.completion_sorting = 'length'
vim.g.completion_auto_change_source = 1
vim.g.completion_chain_complete_list = {
  default = {
    {complete_items = {'lsp'}},
    {complete_items = {'ts'}},
    {mode = '<c-p>'},
    {mode = '<c-n>'},
  },
  clojure = {
    {complete_items = {'conjure'}},
    {complete_items = {'lsp'}},
    {mode = '<c-p>'},
    {mode = '<c-n>'},
  },
}

local conjure_source = {
  item = function (prefix)
    return vim.tbl_map(
      function (item)
        return vim.tbl_extend('keep', item, { user_data = { hover = item.info } })
      end,
      require'conjure.eval'["completions-sync"](prefix))
  end
}

completion.addCompletionSource('conjure', conjure_source)

