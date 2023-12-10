---@type LazySpec
local M = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "rcarriga/cmp-dap",
    "PaterJason/cmp-conjure",
  },
}

function M.config()
  local cmp = require "cmp"

  vim.keymap.set({ "i", "s" }, "<Tab>", function()
    if vim.snippet.jumpable(1) then
      return "<Cmd>lua vim.snippet.jump(1)<CR>"
    else
      return "<Tab>"
    end
  end, { expr = true })
  vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
    if vim.snippet.jumpable(-1) then
      return "<Cmd>lua vim.snippet.jump(-1)<CR>"
    else
      return "<S-Tab>"
    end
  end, { expr = true })

  ---@diagnostic disable-next-line: missing-fields
  cmp.setup {
    enabled = function()
      return vim.bo.buftype ~= "prompt" or require("cmp_dap").is_dap_buffer()
    end,
    snippet = {
      expand = function(args)
        vim.snippet.expand(args.body)
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
      { name = "nvim_lsp_signature_help" },
      { name = "nvim_lsp" },
    }, {
      { name = "conjure" },
    }),
  }

  ---@diagnostic disable-next-line: missing-fields
  require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
      { name = "dap" },
    },
  })
end

return M
