---@type LazySpec
local M = {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/nvim-treesitter-refactor",
    "nvim-treesitter/nvim-treesitter-context",
    "PaterJason/nvim-treesitter-sexp",
  },
  build = ":TSUpdate",
}

function M.config()
  local ensure_installed = {
    "comment",
    "regex",
  }
  for name, type in vim.fs.dir(vim.fs.joinpath(vim.env.VIMRUNTIME, "queries")) do
    if type == "directory" then
      ensure_installed[#ensure_installed + 1] = name
    end
  end

  ---@diagnostic disable-next-line: missing-fields
  require("nvim-treesitter.configs").setup {
    ensure_installed = ensure_installed,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = false,
        node_incremental = "an",
        scope_incremental = "aN",
        node_decremental = "in",
      },
    },
    indent = {
      enable = true,
    },
    refactor = {
      highlight_definitions = {
        enable = true,
        clear_on_cursor_move = false,
      },
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = "<Leader>rn",
        },
      },
      navigation = {
        enable = true,
        keymaps = {
          goto_definition = "gnd",
          list_definitions = "gnD",
          list_definitions_toc = "gO",
          goto_next_usage = "]g",
          goto_previous_usage = "[g",
        },
      },
    },
  }

  vim.keymap.set("n", "gC", function()
    require("treesitter-context").go_to_context()
  end, { silent = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id) or {}
      local methods = vim.lsp.protocol.Methods

      if client.supports_method(methods.textDocument_documentHighlight) then
        vim.cmd "TSBufDisable refactor.highlight_definitions"
      end
    end,
  })
  vim.api.nvim_create_autocmd("LspDetach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id) or {}

      vim.cmd "TSBufEnable refactor.highlight_definitions"
    end,
  })
end

return M
