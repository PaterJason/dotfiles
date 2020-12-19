local config = require 'lspconfig'
local util = require'util'

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
  }

  for lhs, args in pairs(mappings) do
    util.buf_set_keymap(bufnr, 'n', lhs, [[<cmd>lua require'util'.clj_lsp_cmd(]] .. args ..')<CR>')
  end
end

local on_attach = function(client, bufnr)
  local name = client.name
  print(name .. ' attached')

  util.buf_set_maps(bufnr, {
      {'n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>'},
      {'n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>'},
      {'n', '<leader>ld', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>'},
    })

  local capability_mappings = {
    call_hierarchy = {
      {'n','<leader>lli',  '<cmd>lua vim.lsp.buf.incoming_calls()<CR>'},
      {'n','<leader>llo',  '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>'},
    },
    code_action = {
      -- {'n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>'},
      -- {'v', '<leader>la', '<cmd>lua vim.lsp.buf.range_code_action()<CR>'},
      {'n', '<leader>la', '<cmd>Telescope lsp_code_actions<CR>'},
      {'v', '<leader>la', '<cmd>Telescope lsp_range_code_actions<CR>'},
    },
    declaration = {{'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>'}},
    document_formatting = {{'n', '<leader>l=', '<cmd>lua vim.lsp.buf.formatting()<CR>'}},
    document_range_formatting = {{'v', '<leader>l=', '<cmd>lua vim.lsp.buf.range_formatting()<CR>'}},
    document_symbol = {
      -- {'n', '<leader>lld', '<cmd>lua vim.lsp.buf.document_symbol()<CR>'}
      {'n', '<leader>lld', '<cmd>Telescope lsp_document_symbols<CR>'}
    },
    find_references = {
      -- {'n', '<leader>llr', '<cmd>lua vim.lsp.buf.references()<CR>'}
      {'n', '<leader>llr', '<cmd>Telescope lsp_references<CR>'},
    },
    goto_definition = {{'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>'}},
    hover = {{'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>'}},
    implementation = {{'n', '<leader>lli', '<cmd>lua vim.lsp.buf.implementation()<CR>'}},
    rename = {{'n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>'}},
    signature_help = {{'n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>'}},
    type_definition = {{'n', '<leader>lgt', '<cmd>lua vim.lsp.buf.type_definition()<CR>'}},
    workspace_symbol = {
      -- {'n', '<leader>llw', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>'}
      {'n', '<leader>llw', '<cmd>Telescope lsp_workspace_symbols<CR>'}
    },
  }

  for capability, maps_args in pairs(capability_mappings) do
    if client.resolved_capabilities[capability] then
      util.buf_set_maps(bufnr, maps_args)
    end
  end
end

local servers = {
  bashls = {},
  clojure_lsp = {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      clj_map(bufnr)
    end,
    init_options = {
      ['ignore-classpath-directories'] = true,
    }
  },
  clangd = {},
  cssls = {},
  html = {},
  jsonls = {},
  sumneko_lua = {
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
  texlab = {},
  tsserver = {},
  vimls = {},
}

for name, cfg in pairs(servers) do
  config[name].setup(vim.tbl_extend('keep', cfg, {on_attach = on_attach}))
end
