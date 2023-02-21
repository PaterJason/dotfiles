local M = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
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

  require("luasnip.loaders.from_vscode").load()
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
      ["<C-Space>"] = cmp.mapping.complete {},
      ["<CR>"] = cmp.mapping.confirm { select = true },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    },
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "nvim_lsp_signature_help" },
      { name = "nvim_lsp" },
      { name = "luasnip" },
    }, {
      { name = "conjure" },
    }, {
      { name = "buffer" },
    }),
  }

  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "nvim_lsp_document_symbol" },
    }, {
      { name = "buffer" },
    }),
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
