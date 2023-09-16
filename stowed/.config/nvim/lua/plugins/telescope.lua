local function config()
  local telescope = require "telescope"

  telescope.setup {
    defaults = {
      borderchars = {
        preview = { " " },
        prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
        results = { " ", "│", " ", " ", " ", " ", " ", " " },
      },
      history = false,
      layout_config = { height = 25 },
      layout_strategy = "bottom_pane",
      sorting_strategy = "ascending",
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim",
      },
    },
    pickers = {
      builtin = {
        include_extensions = true,
        previewer = false,
        use_default_opts = true,
      },
      colorscheme = { enable_preview = true },
      current_buffer_fuzzy_find = { skip_empty_lines = true },
    },
  }

  telescope.load_extension "fzy_native"
  telescope.load_extension "ui-select"
  telescope.load_extension "dap"

  local nmap = function(keys, builtin, desc)
    vim.keymap.set("n", keys, require("telescope.builtin")[builtin], { desc = desc })
  end

  nmap("<leader><leader>", "builtin", "Telescope Builtins")
  nmap("<leader>/", "current_buffer_fuzzy_find", "[/] Search current buffer")
  nmap("<leader>gf", "git_files", "Search [G]it [F]iles")
  nmap("<leader>gs", "git_status", "Search [G]it [S]tatus")
  nmap("<leader>sb", "buffers", "[S]earch [B]uffers")
  nmap("<leader>sd", "diagnostics", "[S]earch [D]iagnostics")
  nmap("<leader>sf", "find_files", "[S]earch [F]iles")
  nmap("<leader>sg", "live_grep", "[S]earch by [G]rep")
  nmap("<leader>sh", "help_tags", "[S]earch [H]elp")
  nmap("<leader>sl", "loclist", "[S]earch [L]ocation list")
  nmap("<leader>sq", "quickfix", "[S]earch current [W]ord")
  nmap("<leader>sr", "resume", "[S]earch [R]esume")
  nmap("<leader>sw", "grep_string", "[S]earch [Q]uickfix list")
end

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-dap.nvim",
    },
    config = config,
  },
}
