local lsp = require 'lspconfig'
local cmp_lsp = require 'cmp_nvim_lsp'
local util = require 'util'

function _G.clj_lsp_cmd(cmd, prompt)
  local params = vim.lsp.util.make_position_params()
  local args = { params.textDocument.uri, params.position.line, params.position.character }
  if prompt then
    table.insert(args, vim.fn.input(prompt))
  else
  end
  return vim.lsp.buf.execute_command { command = cmd, arguments = args }
end

local function map_clj(bufnr)
  for keymap, args in pairs {
    cc = '"cycle-coll"',
    th = '"thread-first"',
    tt = '"thread-last"',
    tf = '"thread-first-all"',
    tl = '"thread-last-all"',
    uw = '"unwind-thread"',
    ua = '"unwind-all"',
    ml = '"move-to-let", "Binding name: "',
    il = '"introduce-let", "Binding name: "',
    el = '"expand-let"',
    am = '"add-missing-libspec"',
    cn = '"clean-ns"',
    cp = '"cycle-privacy"',
    is = '"inline-symbol"',
    ef = '"extract-function", "Function name: "',
    ai = '"add-import-to-namespace", "Import name: "',
  } do
    util.buf_keymap(bufnr, 'n', ('<leader>r' .. keymap), ('<cmd>call v:lua.clj_lsp_cmd(' .. args .. ')<CR>'))
  end
end

local function on_attach(client, bufnr)
  util.buf_keymaps(bufnr, {
    { 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>' },
    { 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>' },
    { 'n', '<leader>d', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>' },
    { 'n', '<leader>fd', '<cmd>Telescope lsp_document_diagnostics<CR>' },
    { 'n', '<leader>fD', '<cmd>Telescope lsp_workspace_diagnostics<CR>' },
    { 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>' },
    { 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>' },
    { 'n', '<space>wl', '<cmd>lua put(vim.lsp.buf.list_workspace_folders())<CR>' },
  })
  for capability, keymaps in pairs {
    call_hierarchy = {
      { 'n', '<leader>ci', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>' },
      { 'n', '<leader>co', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>' },
    },
    code_action = {
      { 'n', '<leader>a', '<cmd>Telescope lsp_code_actions<CR>' },
      { 'v', '<leader>a', ':Telescope lsp_range_code_actions<CR>' },
    },
    declaration = { { 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>' } },
    document_formatting = { { 'n', '<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>' } },
    document_range_formatting = { { 'v', '<leader>=', '<cmd>lua vim.lsp.buf.range_formatting()<CR>' } },
    document_symbol = { { 'n', 'gs', '<cmd>Telescope lsp_document_symbols<CR>' } },
    find_references = { { 'n', 'gr', '<cmd>Telescope lsp_references<CR>' } },
    goto_definition = { { 'n', 'gd', '<cmd>Telescope lsp_definitions<CR>' } },
    hover = { { 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>' } },
    implementation = { { 'n', 'gi', '<cmd>Telescope lsp_implementations<CR>' } },
    rename = { { 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>' } },
    signature_help = { { 'n', '<leader>K', '<cmd>lua vim.lsp.buf.signature_help()<CR>' } },
    type_definition = { { 'n', '<leader>D', '<cmd>Telescope lsp_type_definitions<CR>' } },
    workspace_symbol = { { 'n', '<leader>ws', '<cmd>Telescope lsp_workspace_symbols<CR>' } },
  } do
    if client.resolved_capabilities[capability] then
      util.buf_keymaps(bufnr, keymaps)
    else
    end
  end
  if client.resolved_capabilities.document_highlight then
    vim.cmd 'autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()'
    vim.cmd 'autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()'
  end
  if client.resolved_capabilities.code_lens then
    vim.cmd 'autocmd BufEnter,BufWritePost <buffer> lua vim.lsp.codelens.refresh()'
    vim.lsp.codelens.refresh()
  end
  print(client.name .. ' attached')
end

local capabilities = cmp_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local servers = {
  cssls = { cmd = { 'vscode-css-languageserver', '--stdio' } },
  html = { cmd = { 'vscode-html-languageserver', '--stdio' } },
  jsonls = { cmd = { 'vscode-json-languageserver', '--stdio' } },
  bashls = {},
  clojure_lsp = {
    init_options = { ['ignore-classpath-directories'] = true },
    on_attach = function(client, bufnr)
      map_clj(bufnr)
      return on_attach(client, bufnr)
    end,
  },
  sumneko_lua = {
    cmd = { 'lua-language-server' },
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.list_extend(vim.split(package.path, ';'), { 'lua/?.lua', 'lua/?/init.lua' }),
        },
        diagnostics = { globals = { 'vim' } },
        workspace = { library = vim.api.nvim_get_runtime_file('', true) },
        telemetry = { enable = false },
      },
    },
  },
  texlab = {
    settings = {
      latex = {
        build = { onSave = true },
        forwardSearch = { onSave = true },
        lint = {
          onChange = true,
        },
      },
    },
  },
  tsserver = {},
  vimls = {},
  hls = {},
}

for server, config in pairs(servers) do
  lsp[server].setup(vim.tbl_extend('keep', config, {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 200 },
  }))
end
