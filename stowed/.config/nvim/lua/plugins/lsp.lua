local lsp = require 'lspconfig'
local cmp_lsp = require 'cmp_nvim_lsp'

vim.diagnostic.config {
  severity_sort = true,
  signs = false,
}

_G.diagnostic_changed = function()
  if vim.fn.getqflist({ title = 0 }).title == 'Diagnostics' then
    vim.diagnostic.setqflist { open = false }
  end
  if vim.fn.getloclist(0, { title = 0 }).title == 'Diagnostics' then
    vim.diagnostic.setloclist { open = false }
  end
end
vim.cmd 'autocmd DiagnosticChanged * lua diagnostic_changed()'

_G.progress_update = function()
  local messages = vim.lsp.util.get_progress_messages()

  if vim.tbl_isempty(messages) then
    return
  end

  local chunks = {}
  for _, message in ipairs(messages) do
    local msg = {}

    if message.name then
      table.insert(msg, string.format('[%s]', message.name))
    end
    if message.title then
      table.insert(msg, message.title)
    end
    if message.message then
      table.insert(msg, message.message)
    end
    if message.done then
      table.insert(msg, 'done')
    elseif message.percentage then
      table.insert(msg, string.format('%d%%', message.percentage))
    end

    table.insert(chunks, table.concat(msg, ' '))
  end

  vim.notify(table.concat(chunks, ' '))
end
vim.cmd 'autocmd User LspProgressUpdate lua progress_update()'

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'solid',
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = 'solid',
})

local function on_attach(client, bufnr)
  local basics = require 'lsp_basics'
  basics.make_lsp_commands(client, bufnr)
  basics.make_lsp_mappings(client, bufnr)

  local cap = client.resolved_capabilities

  local wk = require 'which-key'
  wk.register({
    ['[d'] = { vim.diagnostic.goto_prev, 'Prev diagnostic' },
    [']d'] = { vim.diagnostic.goto_next, 'Next diagnostic' },
    ['gl'] = { vim.diagnostic.open_float, 'Show diagnostics' },
    ['<leader>lq'] = { vim.diagnostic.setloclist, 'Diagnostics loclist' },
    ['<leader>lQ'] = { vim.diagnostic.setqflist, 'Diagnostics quickfix' },
  }, {
    buffer = bufnr,
  })
  if cap.rename then
    vim.cmd 'TSBufDisable refactor.smart_rename'
  end
  for capability, mappings in pairs {
    call_hierarchy = {
      ['<leader>l'] = {
        ['i'] = { vim.lsp.buf.incoming_calls, 'Incoming calls' },
        ['o'] = { vim.lsp.buf.outgoing_calls, 'Outgoing calls' },
      },
    },
    code_action = { ['<leader>la'] = { vim.lsp.buf.code_action, 'Code actions' } },
    declaration = { ['gD'] = { vim.lsp.buf.declaration, 'Declaration' } },
    document_formatting = { ['<leader>lf'] = { vim.lsp.buf.formatting, 'Format' } },
    document_symbol = { ['<leader>ls'] = { vim.lsp.buf.document_symbol, 'Document symbols' } },
    find_references = { ['gr'] = { vim.lsp.buf.references, 'References' } },
    hover = { ['K'] = { vim.lsp.buf.hover, 'Hover' } },
    implementation = { ['gI'] = { vim.lsp.buf.implementation, 'Implementation' } },
    rename = { ['<leader>r'] = { vim.lsp.buf.rename, 'Rename' } },
    signature_help = { ['gs'] = { vim.lsp.buf.signature_help, 'Signature help' } },
    type_definition = { ['<leader>lt'] = { vim.lsp.buf.type_definition, 'Type definitions' } },
    workspace_symbol = { ['<leader>lS'] = { vim.lsp.buf.workspace_symbol, 'Workspace symbols' } },
  } do
    if cap[capability] then
      wk.register(mappings, { buffer = bufnr })
    end
  end
  if cap.document_highlight then
    vim.cmd 'TSBufDisable refactor.highlight_definitions'
    vim.cmd 'autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()'
    vim.cmd 'autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()'
  end
  if cap.code_lens then
    vim.cmd 'autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()'
  end
  if cap.document_range_formatting then
    vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr()'
  end
  vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  vim.notify(client.name .. ' attached')
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
  taplo = {},
  yamlls = {},
} do
  lsp[server].setup(config)
end

local null_ls = require 'null-ls'
null_ls.setup {
  on_attach = on_attach,
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.fish_indent,
  },
}

require('rust-tools').setup {
  tools = {
    inlay_hints = {
      show_parameter_hints = false,
    },
    hover_actions = {
      border = 'solid',
    },
  },
  server = {
    settings = {
      ['rust-analyzer'] = {
        checkOnSave = {
          command = 'clippy',
          extraArgs = { '--', '-W', 'clippy::pedantic' },
        },
        diagnostics = {
          warningsAsInfo = { 'clippy::pedantic' },
        },
      },
    },
  },
}
