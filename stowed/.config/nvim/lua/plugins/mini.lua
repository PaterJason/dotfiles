require("mini.ai").setup { n_lines = 100 }

require("mini.bufremove").setup {}
vim.keymap.set("n", "<leader>bd", MiniBufremove.delete, { desc = "Buffer delete" })
vim.keymap.set("n", "<leader>bw", MiniBufremove.wipeout, { desc = "Buffer wipeout" })

require("mini.base16").setup {
  palette = {
    base00 = "#ffffff",
    base01 = "#e0e0e0",
    base02 = "#d6d6d6",
    base03 = "#8e908c",
    base04 = "#969896",
    base05 = "#4d4d4c",
    base06 = "#282a2e",
    base07 = "#1d1f21",
    base08 = "#c82829",
    base09 = "#f5871f",
    base0A = "#eab700",
    base0B = "#718c00",
    base0C = "#3e999f",
    base0D = "#4271ae",
    base0E = "#8959a8",
    base0F = "#a3685a",
  },
  use_cterm = true,
}

require("mini.comment").setup {}

require("mini.jump").setup {}

require("mini.pairs").setup {}

require("mini.statusline").setup { use_icons = false }

require("mini.surround").setup {
  mappings = {
    add = "ys",
    delete = "ds",
    find = "",
    find_left = "",
    highlight = "",
    replace = "cs",
    update_n_lines = "",
  },
  n_lines = 100,
}
vim.keymap.del("x", "ys")
vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]])
vim.keymap.set("n", "yss", "ys_", { remap = true })

require("mini.tabline").setup { use_icons = false }
