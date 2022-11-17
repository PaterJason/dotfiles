require("neodev").setup {}
local ih = require "lsp-inlayhints"
ih.setup()

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
vim.keymap.set("n", "<leader>m", "<cmd>Mason<CR>", { desc = "Mason" })

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })

local augroup = vim.api.nvim_create_augroup("Lsp", {})
local attach_augroup = vim.api.nvim_create_augroup("lsp_attach", {})
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if string.match(vim.fn.expand("#" .. bufnr .. ":t"), "^conjure%-log%-") then
      vim.diagnostic.disable(bufnr)
    end

    vim.api.nvim_clear_autocmds { group = attach_augroup, buffer = bufnr }
    ih.on_attach(client, bufnr, false)

    local caps = client.server_capabilities

    local t = package.loaded["telescope.builtin"]
    for _, value in ipairs {
      { "callHierarchyProvider", "<leader>li", vim.lsp.buf.incoming_calls, "Incoming calls" },
      { "callHierarchyProvider", "<leader>lo", vim.lsp.buf.outgoing_calls, "Outgoing calls" },
      { "codeActionProvider", "<leader>a", vim.lsp.buf.code_action, "Code actions" },
      { "declarationProvider", "gD", vim.lsp.buf.declaration, "Declaration" },
      { "definitionProvider", "gd", t.lsp_definitions, "Goto Definition" },
      { "documentFormattingProvider", "<leader>lf", vim.lsp.buf.format, "Format" },
      { "documentSymbolProvider", "<leader>ls", t.lsp_document_symbols, "Document symbols" },
      { "hoverProvider", "K", vim.lsp.buf.hover, "Hover" },
      { "implementationProvider", "gi", t.lsp_implementations, "Implementation" },
      { "referencesProvider", "gr", t.lsp_references, "References" },
      { "renameProvider", "<leader>r", vim.lsp.buf.rename, "Rename" },
      { "signatureHelpProvider", "gs", vim.lsp.buf.signature_help, "Signature help" },
      { "typeDefinitionProvider", "<leader>ld", t.lsp_type_definitions, "Type definitions" },
      { "workspaceSymbolProvider", "<leader>lw", t.lsp_dynamic_workspace_symbols, "Workspace symbols" },
    } do
      local cap, lhs, rhs, desc = unpack(value)
      if caps[cap] then
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
      end
    end

    if caps.documentHighlightProvider then
      vim.api.nvim_create_autocmd(
        "CursorHold",
        { callback = vim.lsp.buf.document_highlight, group = attach_augroup, buffer = bufnr }
      )
      vim.api.nvim_create_autocmd(
        "CursorMoved",
        { callback = vim.lsp.buf.clear_references, group = attach_augroup, buffer = bufnr }
      )
    end
    if caps.codeLensProvider then
      vim.api.nvim_create_autocmd(
        { "BufEnter", "CursorHold", "InsertLeave" },
        { callback = vim.lsp.codelens.refresh, group = attach_augroup, buffer = bufnr }
      )
    end

    if caps.documentRangeFormattingProvider then
      vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
    end
    vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    vim.notify(client.name .. " attached", vim.log.levels.INFO)
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = augroup,
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- vim.api.nvim_clear_autocmds { group = attach_augroup, buffer = bufnr }
    -- for _, value in ipairs(keymaps) do
    --   local _, lhs, _, _ = unpack(value)
    --   vim.keymap.del("n", lhs, { buffer = bufnr })
    -- end
    -- vim.notify(client.name .. " detached", vim.log.levels.INFO)
  end,
})

lspconfig.util.default_config.capabilities =
  vim.tbl_extend("force", lspconfig.util.default_config.capabilities, require("cmp_nvim_lsp").default_capabilities())
lspconfig.util.default_config.capabilities.textDocument.colorProvider = { dynamicRegistration = true }

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
    on_attach = require("sqls").on_attach,
  },
  sumneko_lua = {
    settings = {
      Lua = {
        hint = {
          enable = true,
        },
      },
    },
  },
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
  tsserver = {
    settings = {
      typescript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
    },
  },
  lemminx = {},
  marksman = {},
} do
  lspconfig[server].setup(config)
end

do
  local extension_path = vim.fn.stdpath "data" .. "/mason/packages/codelldb/extension/"
  local codelldb_path = extension_path .. "adapter/codelldb"
  local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
  require("rust-tools").setup {
    server = {
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = { command = "clippy", extraArgs = { "--", "-W", "clippy::pedantic" } },
          diagnostics = { warningsAsInfo = { "clippy::pedantic" } },
        },
      },
    },
    dap = { adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path) },
    tools = { hover_actions = { border = "single" } },
  }
end

local null_ls = require "null-ls"
null_ls.setup {
  sources = {
    null_ls.builtins.formatting.stylua,
  },
}
