MiniDeps.later(function()
  MiniDeps.add({
    source = "hrsh7th/nvim-cmp",
    depends = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "rcarriga/cmp-dap",
    },
  })

  local cmp = require("cmp")

  cmp.setup({
    enabled = function() return vim.bo.buftype ~= "prompt" or require("cmp_dap").is_dap_buffer() end,
    snippet = {
      expand = function(args) vim.snippet.expand(args.body) end,
    },
    window = {
      completion = cmp.config.window.bordered({ border = "single" }),
      documentation = cmp.config.window.bordered({ border = "single" }),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-d>"] = cmp.mapping.scroll_docs(8),
      ["<C-u>"] = cmp.mapping.scroll_docs(-8),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp_signature_help" },
      { name = "nvim_lsp" },
    }, {
      { name = "conjure" },
    }),
  })

  require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
      { name = "dap" },
    },
  })
end)
