local telescope = require "telescope"

telescope.setup {
  defaults = {
    color_devicons = false,
    history = false,
    layout_config = {
      height = 0.4,
    },
    layout_strategy = "bottom_pane",
    sorting_strategy = "ascending",
  },
  pickers = {
    builtin = { include_extensions = true },
    colorscheme = { enable_preview = true },
    current_buffer_fuzzy_find = { skip_empty_lines = true },
    symbols = { sources = { "emoji", "latex" } },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_cursor {},
    },
  },
}

telescope.load_extension "fzy_native"
telescope.load_extension "ui-select"
telescope.load_extension "dap"
telescope.load_extension "file_browser"

vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope<CR>", { desc = "Telescope builtins" })

vim.keymap.set("n", "<leader>sb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>sc", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Current buffer" })
vim.keymap.set("n", "<leader>sf", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<CR>", { desc = "Grep" })
vim.keymap.set("n", "<leader>sG", "<cmd>Telescope grep_string<CR>", { desc = "Grep string" })
vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<CR>", { desc = "Help" })
vim.keymap.set("n", "<leader>sl", "<cmd>Telescope loclist<CR>", { desc = "Loclist" })
vim.keymap.set("n", "<leader>sq", "<cmd>Telescope quickfix<CR>", { desc = "Quickfix" })
