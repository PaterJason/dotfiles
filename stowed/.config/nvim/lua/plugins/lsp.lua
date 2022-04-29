local lsp = require 'lspconfig'

local augroup = vim.api.nvim_create_augroup('Lsp', {})

vim.api.nvim_create_autocmd('User', {
  pattern = 'LspProgressUpdate',
  callback = function()
    local messages = vim.lsp.util.get_progress_messages()

    if vim.tbl_isempty(messages) then
      return
    end

    local msg = ''
    for _, message in ipairs(messages) do
      if msg ~= '' then
        msg = string.format('%s | ', msg)
      end
      if message.name then
        msg = string.format('%s[%s]', msg, message.name)
      end
      if message.title then
        msg = string.format('%s %s', msg, message.title)
      end
      if message.message then
        msg = string.format('%s %s', msg, message.message)
      end
      if message.done then
        msg = string.format('%s done', msg, message.message)
      elseif message.percentage then
        msg = string.format('%s %d%%', msg, message.percentage)
      end
    end

    vim.api.nvim_echo({ { msg } }, false, {})
  end,
  group = augroup,
})

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'solid',
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = 'solid',
})

local function on_attach(client, bufnr)
  vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }

  local caps = client.server_capabilities

  for cap, keymaps in
    pairs {
      callHierarchyProvider = {
        { '<leader>li', vim.lsp.buf.incoming_calls, 'Incoming calls' },
        { '<leader>lo', vim.lsp.buf.outgoing_calls, 'Outgoing calls' },
      },
      codeActionProvider = { { '<leader>la', vim.lsp.buf.code_action, 'Code actions' } },
      declarationProvider = { { 'gD', vim.lsp.buf.declaration, 'Declaration' } },
      documentFormattingProvider = { { '<leader>lf', vim.lsp.buf.formatting, 'Format' } },
      documentSymbolProvider = { { '<leader>ls', '<cmd>Telescope lsp_document_symbols<CR>', 'Document symbols' } },
      referencesProvider = { { 'gr', '<cmd>Telescope lsp_references<CR>', 'References' } },
      definitionProvider = { { 'gd', '<cmd>Telescope lsp_definitions<CR>', 'Goto Definition' } },
      hoverProvider = { { 'K', vim.lsp.buf.hover, 'Hover' } },
      implementationProvider = { { 'gi', '<cmd>Telescope lsp_implementations<CR>', 'Implementation' } },
      renameProvider = { { '<leader>r', vim.lsp.buf.rename, 'Rename' } },
      signatureHelpProvider = { { 'gs', vim.lsp.buf.signature_help, 'Signature help' } },
      typeDefinitionProvider = { { '<leader>ld', '<cmd>Telescope lsp_type_definitions<CR>', 'Type definitions' } },
      workspaceSymbolProvider = {
        { '<leader>lw', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', 'Workspace symbols' },
      },
    }
  do
    if caps[cap] then
      for _, value in ipairs(keymaps) do
        vim.keymap.set('n', value[1], value[2], { buffer = bufnr, desc = value[3] })
      end
    end
  end

  if caps.documentHighlightProvider then
    vim.api.nvim_create_autocmd('CursorHold', {
      callback = vim.lsp.buf.document_highlight,
      group = augroup,
      buffer = bufnr,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      callback = vim.lsp.buf.clear_references,
      group = augroup,
      buffer = bufnr,
    })
  end
  if caps.codeLensProvider then
    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
      callback = vim.lsp.codelens.refresh,
      group = augroup,
      buffer = bufnr,
    })
  end

  if caps.documentRangeFormattingProvider then
    vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr()'
  end
  vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  vim.notify(client.name .. ' attached')
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

lsp.util.default_config.on_attach = on_attach
lsp.util.default_config.capabilities = capabilities
lsp.util.default_config.flags = { debounce_text_changes = 250 }

require('lspconfig').available_servers()
for server, config in
  pairs {
    cssls = { cmd = { 'vscode-css-languageserver', '--stdio' } },
    html = { cmd = { 'vscode-html-languageserver', '--stdio' } },
    jsonls = { cmd = { 'vscode-json-languageserver', '--stdio' } },
    bashls = {},
    clojure_lsp = { init_options = { ['ignore-classpath-directories'] = true } },
    sumneko_lua = string.match(vim.loop.cwd(), '/nvim') and require('lua-dev').setup {} or {},
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
    taplo = { cmd = { 'taplo', 'lsp', 'stdio' } },
    yamlls = {},
  }
do
  lsp[server].setup(config)
end

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
