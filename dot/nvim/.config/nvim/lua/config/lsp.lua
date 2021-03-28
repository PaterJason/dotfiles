local lsp = require'lspconfig'
local util = require'util'

function _G.clj_lsp_cmd (cmd, prompt)
  local params = vim.lsp.util.make_position_params()
  local args = {params.textDocument.uri , params.position.line, params.position.character}
  if prompt then
    local input = vim.fn.input(prompt)
    table.insert(args, input)
  end
  vim.lsp.buf.execute_command({
    command = cmd,
    arguments = args,
  })
end

local clj_map = function(bufnr)
  local mappings = {
    ['<leader>rcc'] = [['cycle-coll']],
    ['<leader>rth'] = [['thread-first']],
    ['<leader>rtt'] = [['thread-last']],
    ['<leader>rtf'] = [['thread-first-all']],
    ['<leader>rtl'] = [['thread-last-all']],
    ['<leader>ruw'] = [['unwind-thread']],
    ['<leader>rua'] = [['unwind-all']],
    ['<leader>rml'] = [['move-to-let', 'Binding name: ']],
    ['<leader>ril'] = [['introduce-let', 'Binding name: ']],
    ['<leader>rel'] = [['expand-let']],
    ['<leader>ram'] = [['add-missing-libspec']],
    ['<leader>rcn'] = [['clean-ns']],
    ['<leader>rcp'] = [['cycle-privacy']],
    ['<leader>ris'] = [['inline-symbol']],
    ['<leader>ref'] = [['extract-function', 'Function name: ']],
    ['<leader>rai'] = [['add-import-to-namespace', 'Import name: ']],
  }

  for lhs, args in pairs(mappings) do
    util.buf_set_keymap(bufnr, 'n', lhs, '<cmd>call v:lua.clj_lsp_cmd(' .. args ..')<CR>')
  end
end

local on_attach = function(client, bufnr)
  util.buf_set_keymaps(bufnr, {
    {'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>'},
    {'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>'},
    {'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>'},
    {'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>'},
    {'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>'},
    {'n', '<space>wl', '<cmd>lua dump(vim.lsp.buf.list_workspace_folders())<CR>'},
  })

  local capability_mappings = {
    call_hierarchy = {
      {'n','<leader>ci',  '<cmd>lua vim.lsp.buf.incoming_calls()<CR>'},
      {'n','<leader>co',  '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>'},
    },
    code_action = {
      {'n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>'},
      {'v', '<leader>a', '<cmd>lua vim.lsp.buf.range_code_action()<CR>'},
      {'n', '<leader>fa', '<cmd>Telescope lsp_code_actions<CR>'},
      {'v', '<leader>fa', '<cmd>Telescope lsp_range_code_actions<CR>'},
    },
    declaration = {{'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>'}},
    document_formatting = {{'n', '<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>'}},
    document_range_formatting = {{'v', '<leader>=', '<cmd>lua vim.lsp.buf.range_formatting()<CR>'}},
    document_symbol = {
      {'n', 'gs', '<cmd>lua vim.lsp.buf.document_symbol()<CR>'},
      {'n', '<leader>fs', '<cmd>Telescope lsp_document_symbols<CR>'},
    },
    find_references = {
      {'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>'},
      {'n', '<leader>fr', '<cmd>Telescope lsp_references<CR>'},
    },
    goto_definition = {{'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>'}},
    hover = {{'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>'}},
    implementation = {{'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>'}},
    rename = {{'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>'}},
    signature_help = {{'n', '<leader>K', '<cmd>lua vim.lsp.buf.signature_help()<CR>'}},
    type_definition = {{'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>'}},
    workspace_symbol = {
      {'n', '<leader>ws', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>'},
      {'n', '<leader>fw', '<cmd>Telescope lsp_workspace_symbols<CR>'},
    },
  }

  for capability, maps_args in pairs(capability_mappings) do
    if client.resolved_capabilities[capability] then
      util.buf_set_keymaps(bufnr, maps_args)
    end
  end

  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end

  print(client.name .. ' attached')
end

local servers = {
  bashls = {},
  clojure_lsp = {
    on_attach = function(client, bufnr)
      clj_map(bufnr)
      on_attach(client, bufnr)
    end,
  },
  clangd = {},
  cssls = {},
  html = {},
  jsonls = {},
  sumneko_lua = {
    cmd = {'lua-language-server'},
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = vim.split(package.path, ';'),
        },
        diagnostics = {
          globals = {'vim'},
        },
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          }
        }
      }
    }
  },
  texlab = {
    settings = {
      latex = {
        build = {
          onSave = true
        },
        forwardSearch = {
          onSave = true
        },
        lint = {
          onChange = true
        },
      }
    }
  },
  tsserver = {},
  vimls = {},
  yamlls = {},
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

for server, config in pairs(servers) do
  lsp[server].setup(vim.tbl_extend('keep', config, {
    on_attach = on_attach,
    capabilities = capabilities,
  }))
end
