local M = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "PaterJason/cmp-conjure",
    "rcarriga/cmp-dap",
  },
}

function M.config()
  local cmp = require "cmp"
  local luasnip = require "luasnip"

  require("luasnip.loaders.from_vscode").lazy_load()
  vim.keymap.set("i", "<C-l>", "<Plug>luasnip-expand-or-jump")
  vim.keymap.set("s", "<C-l>", "<Plug>luasnip-expand-or-jump")
  vim.keymap.set("i", "<C-h>", "<Plug>luasnip-jump-prev")
  vim.keymap.set("s", "<C-h>", "<Plug>luasnip-jump-prev")

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
  end

  cmp.setup {
    enabled = function()
      return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
    end,
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ["<C-d>"] = cmp.mapping.scroll_docs(8),
      ["<C-u>"] = cmp.mapping.scroll_docs(-8),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm { select = true },
    },
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "nvim_lsp_signature_help" },
      { name = "luasnip" },
      { name = "nvim_lsp" },
    }, {
      { name = "conjure" },
    }, {
      { name = "buffer" },
    }),
  }

  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })

  cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
      { name = "dap" },
    },
  })
end

return M
