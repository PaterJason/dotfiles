local function config()
  require("nvim-treesitter.configs").setup {
    ensure_installed = "all",
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
    refactor = {
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = "gnr",
        },
      },
      navigation = {
        enable = true,
        keymaps = {
          goto_definition = "gnd",
          list_definitions = "gnD",
          list_definitions_toc = "gO",
          goto_previous_usage = "[g",
          goto_next_usage = "]g",
        },
      },
    },
  }

  require("treesitter-context").setup {
    enable = true,
    patterns = {
      json = {
        "pair",
      },
      clojure = {
        "list_lit",
        "map_lit",
        "vec_lit",
      },
    },
  }
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/nvim-treesitter-refactor",
    },
    build = ":TSUpdate",
    config = config,
  },
}
