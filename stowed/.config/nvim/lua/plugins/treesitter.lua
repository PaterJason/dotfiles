---@type LazySpec
local M = {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
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
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    indent = {
      enable = true,
    },
  }

  vim.keymap.set("n", "gC", function()
    require("treesitter-context").go_to_context()
  end, { silent = true })
end

return M
