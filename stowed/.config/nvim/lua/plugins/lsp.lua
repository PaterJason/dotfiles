MiniDeps.later(function()
  MiniDeps.add({
    source = "neovim/nvim-lspconfig",
    depends = {
      {
        source = "williamboman/mason.nvim",
        hooks = { post_checkout = function() vim.cmd("MasonUpdate") end },
      },
      "b0o/SchemaStore.nvim",
      "folke/neodev.nvim",
      "nanotee/sqls.nvim",
    },
    hooks = {},
  })

  require("neodev").setup({})

  require("mason").setup({
    ui = {
      border = "single",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })
  vim.keymap.set("n", "<leader>m", vim.cmd.Mason, { desc = "Mason" })

  local lspconfig = require("lspconfig")

  lspconfig.util.default_config.autostart = false
  vim.api.nvim_create_autocmd("BufReadPost", {
    group = "JPConfigLsp",
    callback = function(args)
      if vim.bo[args.buf].buftype == "" and vim.b[args.buf].bigfile ~= true then
        vim.cmd.LspStart()
      end
    end,
  })

  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  ---@type table<string, lspconfig.Config>
  local server_settings = {
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
    clojure_lsp = {},
    lua_ls = {
      settings = {
        Lua = {
          completion = {
            callSnippet = "Replace",
          },
          hint = { enable = true },
          format = { enable = false },
        },
      },
    },
    sqls = {
      on_attach = function(client, bufnr) require("sqls").on_attach(client, bufnr) end,
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
    tsserver = {
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
    },
    yamlls = {
      settings = {
        yaml = {
          schemas = require("schemastore").yaml.schemas(),
        },
      },
    },
    lemminx = {
      settings = {
        xml = {
          catalogs = { vim.fs.normalize("~/.config/fontconfig/catalog.xml") },
        },
      },
    },
    marksman = {},
  }
  for server, config in pairs(server_settings) do
    config.capabilities = capabilities
    lspconfig[server].setup(config)
  end
end)

MiniDeps.later(function()
  MiniDeps.add({
    source = "mrcjkb/rustaceanvim",
  })

  ---@type RustaceanOpts
  vim.g.rustaceanvim = {
    tools = {
      hover_actions = { border = "single" },
    },
    server = {
      auto_attach = false,
      settings = {
        ["rust-analyzer"] = {
          check = {
            command = "clippy",
            extraArgs = { "--", "-W", "clippy::pedantic" },
          },
          diagnostics = { warningsAsInfo = { "clippy::pedantic" } },
        },
      },
    },
    dap = { autoload_configurations = true },
  }

  vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = { "*.rs" },
    group = "JPConfigLsp",
    callback = function(args)
      if vim.bo[args.buf].buftype == "" then vim.cmd("RustAnalyzer start") end
    end,
  })
end)
