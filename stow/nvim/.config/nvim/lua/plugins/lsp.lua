local lsp = require 'lspconfig'
local cmp_lsp = require 'cmp_nvim_lsp'

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  { severity_sort = true }
)

function _G.clj_lsp_cmd(cmd, prompt)
  local params = vim.lsp.util.make_position_params()
  local args = { params.textDocument.uri, params.position.line, params.position.character }
  if prompt then
    table.insert(args, vim.fn.input(prompt))
  end
  vim.lsp.buf.execute_command { command = cmd, arguments = args }
end

function _G.lsp_formatexr()
  vim.lsp.buf.range_formatting({}, { vim.v.lnum, 0 }, { vim.v.lnum + vim.v.count, 0 })
  return 0
end

local function map_clj(bufnr)
  local wk = require 'which-key'
  local mappings = {
    cc = { { 'cycle-coll' }, 'Cycle coll' },
    th = { { 'thread-first' }, 'Thread first' },
    tt = { { 'thread-last' }, 'Thread last' },
    tf = { { 'thread-first-all' }, 'Thread first all' },
    tl = { { 'thread-last-all' }, 'Thread last all' },
    uw = { { 'unwind-thread' }, 'Unwind thread' },
    ua = { { 'unwind-all' }, 'Unwind all' },
    ml = { { 'move-to-let', 'Binding name: ' }, 'Move to let' },
    il = { { 'introduce-let', 'Binding name: ' }, 'Introduce let' },
    el = { { 'expand-let' }, 'Expand let' },
    am = { { 'add-missing-libspec' }, 'Add missing libspec' },
    cn = { { 'clean-ns' }, 'Clean ns' },
    cp = { { 'cycle-privacy' }, 'Cycle privacy' },
    is = { { 'inline-symbol' }, 'Inline symbol' },
    ef = { { 'extract-function', 'Function name: ' }, 'Extract function' },
    ai = { { 'add-import-to-namespace', 'Import name: ' }, 'Add import to namespace' },
  }
  for keymap, args in pairs(mappings) do
    mappings[keymap][1] = '<cmd>call v:lua.clj_lsp_cmd("' .. table.concat(args[1], '", "') .. '")<CR>'
  end
  wk.register(mappings, {
    prefix = '<leader>r',
    buffer = bufnr,
  })
end

local function on_attach(client, bufnr)
  local wk = require 'which-key'
  wk.register({
    ['[d'] = { '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', 'Prev diagnostic' },
    [']d'] = { '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', 'Next diagnostic' },
    ['<leader>d'] = { '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', 'Show diagnostics' },
    ['<space>w'] = {
      name = 'Workspace',
      a = { '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add folder' },
      r = { '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'Remove folder' },
      l = { '<cmd>lua put(vim.lsp.buf.list_workspace_folders())<CR>', 'List folders' },
    },
  }, {
    buffer = bufnr,
  })
  for capability, mappings in pairs {
    call_hierarchy = {
      ['<leader>c'] = {
        name = 'Calls',
        ['i'] = { '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', 'Incoming' },
        ['o'] = { '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', 'Outgoing' },
      },
    },
    code_action = { ['<leader>a'] = { '<cmd>Telescope lsp_code_actions<CR>', 'Code actions' } },
    declaration = { ['gD'] = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Declaration' } },
    document_symbol = { ['gs'] = { '<cmd>Telescope lsp_document_symbols<CR>', 'Document symbols' } },
    find_references = { ['gr'] = { '<cmd>Telescope lsp_references<CR>', 'References' } },
    goto_definition = { ['gd'] = { '<cmd>Telescope lsp_definitions<CR>', 'Definition' } },
    hover = { ['K'] = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'Hover' } },
    implementation = { ['gi'] = { '<cmd>Telescope lsp_implementations<CR>', 'Implementation' } },
    rename = { ['<leader>rn'] = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename' } },
    signature_help = { ['<leader>K'] = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Signature help' } },
    type_definition = { ['<leader>D'] = { '<cmd>Telescope lsp_type_definitions<CR>', 'Type definitions' } },
    workspace_symbol = { ['<leader>ws'] = { '<cmd>Telescope lsp_workspace_symbols<CR>', 'Symbols' } },
  } do
    if client.resolved_capabilities[capability] then
      wk.register(mappings, { buffer = bufnr })
    end
  end
  if client.resolved_capabilities.document_formatting then
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
  end
  if client.resolved_capabilities.document_range_formatting then
    vim.bo.formatexpr = 'v:lua.lsp_formatexr()'
  end
  if client.resolved_capabilities.document_highlight then
    vim.cmd 'autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()'
    vim.cmd 'autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()'
  end
  if client.resolved_capabilities.code_lens then
    vim.cmd 'autocmd BufEnter,BufModifiedSet,InsertLeave <buffer> lua vim.lsp.codelens.refresh()'
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
      on_attach(client, bufnr)
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
  ['null-ls'] = {},
}

local null_ls = require 'null-ls'

null_ls.config {
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.fish_indent,
  },
}

for server, config in pairs(servers) do
  lsp[server].setup(vim.tbl_extend('keep', config, {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 250 },
  }))
end
