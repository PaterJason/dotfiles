local lsp = require 'lspconfig'
local cmp_lsp = require 'cmp_nvim_lsp'

vim.diagnostic.config {
  severity_sort = true,
  signs = false,
}

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

local function on_attach(client, bufnr)
  local wk = require 'which-key'
  wk.register({
    ['[d'] = { '<cmd>lua vim.diagnostic.goto_prev()<CR>', 'Prev diagnostic' },
    [']d'] = { '<cmd>lua vim.diagnostic.goto_next()<CR>', 'Next diagnostic' },
    ['gl'] = { '<cmd>lua vim.diagnostic.open_float()<CR>', 'Show diagnostics' },
    ['<leaderlq>'] = { '<cmd>lua vim.diagnostic.setloclist()<CR>', 'Diagnostics loclist' },
    ['<leader>ld'] = { '<cmd>Telescope diagnostics bufnr=0<CR>', 'Document diagnostics' },
    ['<leader>lw'] = { '<cmd>Telescope diagnostics<CR>', 'Workspace diagnostics' },
  }, {
    buffer = bufnr,
  })
  for capability, mappings in pairs {
    call_hierarchy = {
      ['<leader>l'] = {
        ['i'] = { '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', 'Incoming calls' },
        ['o'] = { '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', 'Outgoing calls' },
      },
    },
    code_action = { ['<leader>la'] = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'Code actions' } },
    declaration = { ['gD'] = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Declaration' } },
    document_formatting = { ['<leader>lf'] = { '<cmd>lua vim.lsp.buf.formatting()<CR>', 'Format' } },
    document_symbol = { ['<leader>ls'] = { '<cmd>Telescope lsp_document_symbols<CR>', 'Document symbols' } },
    find_references = { ['gr'] = { '<cmd>Telescope lsp_references<CR>', 'References' } },
    goto_definition = { ['gd'] = { '<cmd>Telescope lsp_definitions<CR>', 'Definition' } },
    hover = { ['K'] = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'Hover' } },
    implementation = { ['gI'] = { '<cmd>Telescope lsp_implementations<CR>', 'Implementation' } },
    rename = { ['<leader>lr'] = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename' } },
    signature_help = { ['gs'] = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Signature help' } },
    type_definition = { ['<leader>lt'] = { '<cmd>Telescope lsp_type_definitions<CR>', 'Type definitions' } },
    workspace_symbol = { ['<leader>lS'] = { '<cmd>Telescope lsp_workspace_symbols<CR>', 'Workspace symbols' } },
  } do
    if client.resolved_capabilities[capability] then
      wk.register(mappings, { buffer = bufnr })
    end
  end
  if client.resolved_capabilities.document_range_formatting then
    vim.bo.formatexpr = 'v:lua.lsp_formatexr()'
  end
  if client.resolved_capabilities.document_highlight then
    vim.cmd 'autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()'
    vim.cmd 'autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()'
  end
  if client.resolved_capabilities.code_lens then
    vim.cmd 'autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()'
  end
  print(client.name .. ' attached')
end

local capabilities = cmp_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

lsp.util.default_config.on_attach = on_attach
lsp.util.default_config.capabilities = capabilities
lsp.util.default_config.flags = { debounce_text_changes = 250 }

for server, config in pairs {
  cssls = { cmd = { 'vscode-css-languageserver', '--stdio' } },
  html = { cmd = { 'vscode-html-languageserver', '--stdio' } },
  jsonls = { cmd = { 'vscode-json-languageserver', '--stdio' } },
  bashls = {},
  clojure_lsp = { init_options = { ['ignore-classpath-directories'] = true } },
  sumneko_lua = require('lua-dev').setup {},
  texlab = {
    settings = {
      texlab = {
        build = {
          onSave = true,
          forwardSearchAfter = true,
        },
        forwardSearch = {
          onSave = true,
          executable = 'zathura',
          args = { '--synctex-forward', '%l:1:%f', '%p' },
        },
        chktex = {
          onEdit = true,
          onOpenAndSave = true,
        },
      },
    },
  },
  tsserver = {},
  vimls = {},
  taplo = {},
  yamlls = {},
} do
  lsp[server].setup(config)
end
