local lspconfig = require "lspconfig"

require("mason").setup {
  ui = {
    border = "single",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
}
require("mason-lspconfig").setup {
  ensure_installed = {
    "cssls",
    "eslint",
    "html",
    "jsonls",
    "sumneko_lua",
    "efm",
  },
}
vim.keymap.set("n", "<leader>m", "<cmd>Mason<CR>", { desc = "Mason" })

local augroup = vim.api.nvim_create_augroup("Lsp", {})

_G.lsp_progress_record = {}
vim.api.nvim_create_autocmd("User", {
  pattern = "LspProgressUpdate",
  callback = function()
    local messages = vim.lsp.util.get_progress_messages()

    if vim.tbl_isempty(messages) then
      return
    end

    for _, message in ipairs(messages) do
      local msg = message.name or ""
      if message.title then
        msg = string.format("%s %s", msg, message.title)
      end
      if message.message then
        msg = string.format("%s %s", msg, message.message)
      end
      if message.done then
        msg = string.format("%s done", msg, message.message)
      elseif message.percentage then
        msg = string.format("%s %d%%", msg, message.percentage)
      end
      lsp_progress_record[message.name] = vim.notify(msg, vim.log.levels.INFO, {
        title = "LSP Progress",
        replace = lsp_progress_record[message.name],
      })
    end
  end,
  group = augroup,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "single",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "single",
})

local on_attach = function(client, bufnr)
  vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }

  local caps = client.server_capabilities

  for cap, keymaps in pairs {
    callHierarchyProvider = {
      { "<leader>li", vim.lsp.buf.incoming_calls, "Incoming calls" },
      { "<leader>lo", vim.lsp.buf.outgoing_calls, "Outgoing calls" },
    },
    codeActionProvider = { { "<leader>a", vim.lsp.buf.code_action, "Code actions" } },
    declarationProvider = { { "gD", vim.lsp.buf.declaration, "Declaration" } },
    definitionProvider = { { "gd", "<cmd>Telescope lsp_definitions<CR>", "Goto Definition" } },
    documentFormattingProvider = { { "<leader>lf", vim.lsp.buf.formatting, "Format" } },
    documentSymbolProvider = { { "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", "Document symbols" } },
    hoverProvider = { { "K", vim.lsp.buf.hover, "Hover" } },
    implementationProvider = { { "gi", "<cmd>Telescope lsp_implementations<CR>", "Implementation" } },
    referencesProvider = { { "gr", "<cmd>Telescope lsp_references<CR>", "References" } },
    renameProvider = { { "<leader>r", vim.lsp.buf.rename, "Rename" } },
    signatureHelpProvider = { { "gs", vim.lsp.buf.signature_help, "Signature help" } },
    typeDefinitionProvider = { { "<leader>ld", "<cmd>Telescope lsp_type_definitions<CR>", "Type definitions" } },
    workspaceSymbolProvider = {
      { "<leader>lw", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", "Workspace symbols" },
    },
  } do
    if caps[cap] then
      for _, value in ipairs(keymaps) do
        vim.keymap.set("n", value[1], value[2], { buffer = bufnr, desc = value[3] })
      end
    end
  end

  if caps.documentHighlightProvider then
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = vim.lsp.buf.document_highlight,
      group = augroup,
      buffer = bufnr,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = vim.lsp.buf.clear_references,
      group = augroup,
      buffer = bufnr,
    })
  end
  if caps.codeLensProvider then
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      callback = vim.lsp.codelens.refresh,
      group = augroup,
      buffer = bufnr,
    })
  end

  if caps.documentRangeFormattingProvider then
    vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
  end
  vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  vim.notify(client.name .. " attached", vim.log.levels.INFO, { title = "LSP" })
end
lspconfig.util.default_config.on_attach = on_attach

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
lspconfig.util.default_config.capabilities = capabilities

for server, config in pairs {
  cssls = {},
  eslint = {},
  html = {},
  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
  bashls = {},
  clojure_lsp = { init_options = { ["ignore-classpath-directories"] = true } },
  sqls = {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      require("sqls").on_attach(client, bufnr)
    end,
  },
  sumneko_lua = (string.match(vim.loop.cwd(), "/nvim") and require("lua-dev").setup {}) or {},
  texlab = {
    settings = {
      texlab = {
        build = { onSave = true, forwardSearchAfter = true },
        forwardSearch = {
          onSave = true,
          executable = "zathura",
          args = { "--synctex-forward", "%l:1:%f", "%p" },
        },
        chktex = { onEdit = true, onOpenAndSave = true },
      },
    },
  },
  taplo = {},
  yamlls = {},
  tsserver = {},
  lemminx = {},
  efm = {
    init_options = { documentFormatting = true },
    settings = {
      languages = {
        lua = {
          { formatCommand = "stylua --config-path ~/.config/stylua/stylua.toml -", formatStdin = true },
        },
      },
    },
    filetypes = { "lua" },
  },
  marksman = {},
} do
  lspconfig[server].setup(config)
end

require("rust-tools").setup {
  tools = {
    inlay_hints = {
      show_parameter_hints = false,
    },
    hover_actions = {
      border = "single",
    },
  },
  server = {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
          extraArgs = { "--", "-W", "clippy::pedantic" },
        },
        diagnostics = {
          warningsAsInfo = { "clippy::pedantic" },
        },
      },
    },
  },
}
