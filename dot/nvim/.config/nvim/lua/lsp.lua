local nvim_lsp = require 'nvim_lsp'

local set_keymap = function(bufnr, mode, lhs, rhs)
  local opts = { noremap=true, silent=true }
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
end

local on_attach = function(client, bufnr)
  local name = client.name
  print(name .. " attached")

  require'diagnostic'.on_attach(client, bufnr)

  set_keymap(bufnr, 'n', '[g', '<cmd>PrevDiagnostic<CR>')
  set_keymap(bufnr, 'n', ']g', '<cmd>NextDiagnostic<CR>')
  set_keymap(bufnr, 'n', '<leader>do', '<cmd>OpenDiagnostic<CR>')
  set_keymap(bufnr, 'n', '<leader>ds', '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>')

  if name ~= "bashls" and name ~= "vimls" then
    set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  end
  set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  set_keymap(bufnr, 'v', '<leader>l=', "<cmd>lua require'call'.range_formatting()<CR>")
  set_keymap(bufnr, 'n', '<leader>l=', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  set_keymap(bufnr, 'n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  set_keymap(bufnr, 'n', '<leader>ld', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  set_keymap(bufnr, 'n', '<leader>li', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  set_keymap(bufnr, 'n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>')
  set_keymap(bufnr, 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  set_keymap(bufnr, 'n', '<leader>lt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  set_keymap(bufnr, 'n', '<leader>lw', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
end

local clj_map = function(_, bufnr)
  set_keymap(bufnr, 'n', '<leader>rcc', "<cmd>lua require'call'.clj_lsp_cmd('cycle-coll')<CR>")
  set_keymap(bufnr, 'n', '<leader>rth', "<cmd>lua require'call'.clj_lsp_cmd('thread-first')<CR>")
  set_keymap(bufnr, 'n', '<leader>rtt', "<cmd>lua require'call'.clj_lsp_cmd('thread-last')<CR>")
  set_keymap(bufnr, 'n', '<leader>rtf', "<cmd>lua require'call'.clj_lsp_cmd('thread-first-all')<CR>")
  set_keymap(bufnr, 'n', '<leader>rtl', "<cmd>lua require'call'.clj_lsp_cmd('thread-last-all')<CR>")
  set_keymap(bufnr, 'n', '<leader>ruw', "<cmd>lua require'call'.clj_lsp_cmd('unwind-thread')<CR>")
  set_keymap(bufnr, 'n', '<leader>rua', "<cmd>lua require'call'.clj_lsp_cmd('unwind-all')<CR>")
  set_keymap(bufnr, 'n', '<leader>rml', "<cmd>lua require'call'.clj_lsp_cmd('move-to-let', 'Binding name: ')<CR>")
  set_keymap(bufnr, 'n', '<leader>ril', "<cmd>lua require'call'.clj_lsp_cmd('introduce-let', 'Binding name: ')<CR>")
  set_keymap(bufnr, 'n', '<leader>rel', "<cmd>lua require'call'.clj_lsp_cmd('expand-let')<CR>")
  set_keymap(bufnr, 'n', '<leader>ram', "<cmd>lua require'call'.clj_lsp_cmd('add-missing-libspec')<CR>")
  set_keymap(bufnr, 'n', '<leader>rcn', "<cmd>lua require'call'.clj_lsp_cmd('clean-ns')<CR>")
  set_keymap(bufnr, 'n', '<leader>rcp', "<cmd>lua require'call'.clj_lsp_cmd('cycle-privacy')<CR>")
  set_keymap(bufnr, 'n', '<leader>ris', "<cmd>lua require'call'.clj_lsp_cmd('inline-symbol')<CR>")
  set_keymap(bufnr, 'n', '<leader>ref', "<cmd>lua require'call'.clj_lsp_cmd('extract-function', 'Function name: ')<CR>")
end

nvim_lsp.clojure_lsp.setup{
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    clj_map(client, bufnr)
  end,
  init_options = {
    ["ignore-classpath-directories"] = true,
  }
}

nvim_lsp.sumneko_lua.setup{
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" }
      },
      workspace = {
        library = { [vim.fn.expand("$VIMRUNTIME/lua")] = true }
      }
    }
  }
}

local servers = {'bashls', 'cssls', 'html', 'jsonls', 'vimls'}
for _, server in ipairs(servers) do
  nvim_lsp[server].setup {
    on_attach = on_attach,
  }
end
